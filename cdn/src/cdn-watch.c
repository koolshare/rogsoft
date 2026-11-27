/* Watch the stock installer's completion record. No shell parses the log. */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <string.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static const char log_name[] = "soft_install_log.txt";
static const char marker[] = "XU6J03M6\n";

static bool installation_finished(void)
{
    char tail[sizeof(marker)];
    struct stat st;
    int fd = open("upload/soft_install_log.txt", O_RDONLY | O_NOFOLLOW | O_NONBLOCK);
    bool finished = false;

    if (fd >= 0 && fstat(fd, &st) == 0 && S_ISREG(st.st_mode)) {
        off_t offset = st.st_size > (off_t)sizeof(tail) ? st.st_size - sizeof(tail) : 0;
        ssize_t count = pread(fd, tail, sizeof(tail), offset);
        size_t len = sizeof(marker) - 1;
        if (count == (ssize_t)len && offset == 0)
            finished = memcmp(tail, marker, len) == 0;
        else if (count == (ssize_t)sizeof(tail))
            finished = tail[0] == '\n' && memcmp(tail + 1, marker, len) == 0;
    }
    if (fd >= 0)
        close(fd);
    return finished;
}

static void check_log(const char *handler)
{
    if (!installation_finished())
        return;

    pid_t child = fork();
    if (child == 0) {
        execl(handler, handler, "install-event", (char *)NULL);
        _exit(127);
    }
    if (child > 0)
        while (waitpid(child, NULL, 0) < 0 && errno == EINTR) {}
}

/* Watch the parent only while upload/ is missing. Install that watch first
 * so a directory created during setup cannot be missed. */
static int watch_directory(int fd, const char *handler)
{
    int parent = inotify_add_watch(fd, ".", IN_CREATE | IN_MOVED_TO);
    if (parent < 0)
        return -1;
    int upload = inotify_add_watch(fd, "upload", IN_ONLYDIR | IN_DONT_FOLLOW |
                                   IN_CLOSE_WRITE | IN_MOVED_TO | IN_MOVE_SELF | IN_DELETE_SELF);
    if (upload >= 0) {
        inotify_rm_watch(fd, parent);
        check_log(handler);
    } else if (errno != ENOENT && errno != ENOTDIR && errno != ELOOP) {
        return -1;
    }

    for (;;) {
        char buf[4096] __attribute__((aligned(__alignof__(struct inotify_event))));
        ssize_t count = read(fd, buf, sizeof(buf));
        if (count < 0 && errno == EINTR)
            continue;
        if (count <= 0)
            return -1;
        bool check = false;
        for (ssize_t i = 0; i < count;) {
            const struct inotify_event *ev = (const void *)(buf + i);
            i += sizeof(*ev) + ev->len;
            /* Rebuild both watches and recheck the file after event loss. */
            if (ev->mask & IN_Q_OVERFLOW)
                return 0;
            if (upload < 0 && ev->wd == parent && ev->len && !strcmp(ev->name, "upload"))
                return 0;
            if (ev->wd != upload)
                continue;
            if (ev->mask & (IN_IGNORED | IN_MOVE_SELF | IN_DELETE_SELF))
                return 0;
            if (ev->len && !(ev->mask & IN_ISDIR) && !strcmp(ev->name, log_name))
                check = true;
        }
        if (check)
            check_log(handler);
    }
}

int main(int argc, char **argv)
{
    if (argc != 3 || argv[2][0] != '/' || chdir(argv[1]) != 0)
        return 1;
    for (;;) {
        int fd = inotify_init1(IN_CLOEXEC);
        if (fd < 0)
            return 1;
        int result = watch_directory(fd, argv[2]);
        close(fd);
        if (result < 0)
            return 1;
    }
}
