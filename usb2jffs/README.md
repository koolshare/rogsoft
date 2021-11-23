# USB2JFFS - 用U盘来挂载jffs

> 这是个README.md，从开发插件过程中的笔记整理而来，比较杂乱，纯记录用。
>
> -- by sadog

做这个插件的源起是因为我的一台不争气的RT-AC86U，竟然有15个坏块，加上自己懒癌一直懒得换货。

然后萌发了要做这么一个插件的想法，

中间断断续续写了一些开发文档，终于这次一鼓作气给做出来了。

```bash
# 来看看这15个坏块，86U这品控烂出天际了都
admin@RT-AC86U-9DE0:/tmp/home/root# dmesg|grep "bad block"
nand_read_bbt: bad block at 0x000004e00000
nand_read_bbt: bad block at 0x000005160000
nand_read_bbt: bad block at 0x0000051e0000
nand_read_bbt: bad block at 0x000005da0000
nand_read_bbt: bad block at 0x0000062c0000
nand_read_bbt: bad block at 0x0000063e0000
nand_read_bbt: bad block at 0x000007b00000
nand_read_bbt: bad block at 0x000007e80000
nand_read_bbt: bad block at 0x0000086e0000
nand_read_bbt: bad block at 0x000009920000
nand_read_bbt: bad block at 0x00000c3c0000
nand_read_bbt: bad block at 0x00000c860000
nand_read_bbt: bad block at 0x00000d200000
nand_read_bbt: bad block at 0x00000d980000
nand_read_bbt: bad block at 0x00000ebc0000
```

## 手动实现U盘挂载jffs

要实现U盘挂载jffs本身不难，以RT-AC86U为例

1. **插上U盘**

   > 插上U盘后系统会自动将其挂载好，使用`df -h`命令，可以看到我们的U盘挂载到什么路径了，比如我的：U盘`/dev/sda` 挂载到了 `/tmp/mnt/sadog`（倒数第二行）；同时也知道了，固件原始的jffs挂载文件系统是`/dev/mtdblock8 ` (RT-AX88U等axhnd机型是/dev/mtdblock9 )

   ```bash
   admin@RT-AC86U-9DE0:/tmp/mnt# df -h
   Filesystem                Size      Used Available Use% Mounted on
   ubi:rootfs_ubifs         77.2M     55.3M     21.8M  72% /
   devtmpfs                214.9M         0    214.9M   0% /dev
   tmpfs                   215.0M    496.0K    214.5M   0% /var
   tmpfs                   215.0M      2.6M    212.4M   1% /tmp/mnt
   mtd:bootfs                4.4M      3.3M      1.1M  76% /bootfs
   tmpfs                   215.0M      2.6M    212.4M   1% /tmp/mnt
   mtd:data                  8.0M      2.3M      5.7M  29% /data
   tmpfs                   215.0M      2.6M    212.4M   1% /tmp
   /dev/sdb                  7.3G    529.6M      6.4G   8% /tmp/mnt/sdb
   /dev/sda                 14.5G      1.1G     12.7G   8% /tmp/mnt/sadog
   /dev/mtdblock8           48.0M      7.8M     40.2M  16% /jffs
   ```


2. **卸载jffs**

   > 卸载jffs前需要关闭软件中心进程，因为skipd的数据库是存在/jffs/db下的，httpdb程序本身也是在/jffs/.koolshare/bin目录下的，所以需要关闭这两个进程。
   >
   > 实际上路由器的流量统计等功能也会用jffs作为储存，但是这些进程是间隔时间写入数据的，所以不用太严格考虑重启这些进程。

   ```bash
   # 先关闭skipd和httpdb进程
   killall skipd
   /koolshare/perp/perp.sh stop
   # 卸载jffs分区
   umount -l /jffs
   ```

3. **用U盘挂载jffs**

   ```bash
   # 将jffs分区里的所有文件复制到U盘.koolshare_jffs目录
   cp -a /jffs/ /tmp/mnt/sadog/.koolshare_jffs
   
   # 用刚才创建的文件夹文件夹替换/jffs
   mount -o rbind /tmp/mnt/sadog/.koolshare_jffs /jffs
   
   # 重启软件中心相关进程
   service restart_skipd
   /koolshare/perp/perp.sh start
   ```

至此，就实现了jffs的USB挂载，实际操作下来也就几个命令，看来要实现插件化并没有那么难？

## 手动恢复原始jffs挂载方式

还是以RT-AC86U为例：

1. 卸载jffs

   ```bash
   # 先关闭skipd和httpdb进程
   killall skipd
   /koolshare/perp/perp.sh stop
   # 卸载jffs分区
   umount -l /jffs
   ```

2. 重新挂载jffs

   ```bash
   # 用原始的jffs挂载文件系统/dev/mtdblock8挂载jffs
   mount -t jffs2 -o rw,noatime /dev/mtdblock8 /jffs
   
   # 重启软件中心相关进程
   service restart_skipd
   /koolshare/perp/perp.sh start
   ```

至此，就恢复了jffs的原始挂载方式。

## 还缺点什么

虽然简单的几个命令，就实现了jffs的USB挂载和卸载，但是要做成插件，肯定是远远不够的，还要考虑诸多的点。

1. 开机自启
2. U盘卸载/插拔
3. 文件同步
4. 性能如何

## 开机自启

插件本身的开机自启并不是问题，这个用merlin固件的post-mount脚本就能解决，梅林的post-mount脚本是在一个磁盘挂载成功后触发运行的一个脚本，其位置在/jffs/scripts目录下。

一个关键问题是要弄清楚USB的挂载在系统启动后什么时候启动，因为软件中心本身还涉及到依赖service-start，wan-start，nat-start等开机自启插件。

1. 如果USB磁盘的挂载触发post-mount在所有自启脚本的最后才会触发，那么软件中心这个时候已经运行了原始jffs里的插件了。

2. 如果USB磁盘的挂载触发是在所有其它插件运行之前就触发，那么就只需要这个时候提前替换掉jffs，但是有存在有些很差的U盘需要挂载很久才能挂载上的，导致触发延后
3. 如果USB磁盘的挂载触发时间点是混在中间的，那么可能会导致jffs替换后，后面的插件无法征程开机启动。

为此，我进行了一番测试调查：

### 脚本运行顺序-1

在koolshare梅林改版固件中：

1. jffs挂载后，最开始会运行**`jffsinit.sh`**
2. 然后会运行**`/jffs/.asusrouter`**，即**`/jffs/.koolshare/bin/kscore.sh`**
3. 然后会运行**`/jffs/scripts/init-start`**


- `jffsinit.sh`会在没有/jffs/.koolshare文件夹的时候将/rom的软件中心复制到/jffs，并且创建wan-start，nat-start，post-mount等开机启动脚本；如果有/jffs/.koolshare，则会检查/jffs/scripts下的启动文件是否正常。并且负责创建 /tmp/upload文件夹。这个脚本可以说是koolshare梅林系统里最早的开机启动，在所有系统服务和所有其它任何开机启动脚本之前，因为其的重要性，将其进行固化在固件，只单纯用于软件中心的初始化和其它开机脚本正确与否的检测。

- `.asusrouter`的启动顺序仅次于jffsinit.sh，其在软件中心的作用同样负责检查开机文件，作为双保险，并且负责启动httpdb进程，用命令`ps`可以看到如下：pid 927 进程是和jffs挂载相关的进程，接下来就是.asusrouter启动了perp （perpboot, tinylog, perpd），perp启动了httpdb进程！启动甚至比系统日志进程（syslogd）还要早！`.asusrouter`这个启动脚本在梅林固件384_12_0版本中被列为**过时的**功能，并将其代码进行了注释，可能是其考虑到功能和`init-start`重复了吧，但是在koolshare的梅林改版固件中，为了兼容软件中心的启动方式，仍然保留了这个功能。

  ```bash
    677 admin        0 SW   [wfd1-thrd]
    925 admin     8664 S    console
    927 admin        0 SWN  [jffs2_gcd_mtd9]
    966 admin     1592 S    perpboot -d
    968 admin     1732 S    tinylog -k 3 -s 50000 -t /var/log/perpd
    969 admin     1780 S    perpd -a 6 /koolshare/perp
    971 admin     1108 S    httpdb
   1040 admin     3480 S    /sbin/syslogd -m 0 -S -O /tmp/syslog.log -s 256 -l 6
   1042 admin     3480 S    /sbin/klogd -c 5
   1062 admin        0 SW   [kworker/3:2]
   1086 admin     8664 S    /sbin/wanduck
   1098 admin    11296 S    nt_monitor
   1099 admin     5448 S    protect_srv
   1100 admin    10712 S    /sbin/netool
   1101 admin     2640 S    /usr/bin/skipd
   1114 admin    11808 S    nt_center
   1118 admin     2352 S    dropbear -p 222 -a
  ```

- `init-start` 梅林WIKI：Called right after JFFS got mounted, and before any of the services get started. This is the earliest part of the boot process where you can insert something. 在梅林固件中，init-start在jffs分区刚刚挂载完成后就会启动（start_jffs2函数运行完毕后即运行init-start），并且这个时候还没有任何的系统服务（services）被启动，这在梅林固件被称为启动顺序第一位的，但是在kooshare改版固件中，这个脚本的启动时间排在第三。

以上信息主要涉及到jffs的挂载，以及最早的几个开机脚本的触发，都没有涉及到USB的挂载。至少说明

1. jffs挂载非常早，早于USB挂载
2. jffs挂载后，在koolshare改本梅林固件中，触发了3个脚本，其中2个是软件中心相关的，此时软件中心部分进程也起来了

### 脚本运行顺序-2

进一步了解改版梅林固件的所有脚本启动顺序，对所有脚本都创建了日志输出后：

```bash
# 测试启动顺序结果2 AX88U pppoe拨号
Sat May 5 13:05:04 GMT 2018 asusrouter-jffs-start
Sat May 5 13:05:05 GMT 2018 asusrouter-jffs-end
Sat May 5 13:05:05 GMT 2018 init-start-start
Sat May 5 13:05:18 GMT 2018 service-start-start
Sat May 5 13:05:18 GMT 2018 wan-event-start 0 init
Sat May 5 13:05:18 GMT 2018 wan-event-start 0 connecting
Sat May 5 13:05:20 GMT 2018 service-start-end
Sat May 5 13:05:21 CST 2018 pre-mount-start /dev/sda ext3
Sat May 5 13:05:21 CST 2018 script_usbmount-start
Sat May 5 13:05:22 CST 2018 mount-start-start /dev/sda ext3
Sat May 5 13:05:23 CST 2018 mount-start-end /dev/sda ext3
Sat May 5 13:05:23 CST 2018 wan-event-start 0 connected
Sat May 5 13:05:23 CST 2018 wan-start-start
Sat May 5 13:05:27 GMT 2018 nat-start-start
Sat May 5 13:05:32 GMT 2018 nat-start-start
Sat May 5 13:05:39 GMT 2018 nat-start-end
Sat May 5 13:05:42 GMT 2018 nat-start-end
Sat May 5 13:05:44 CST 2018 wan-start-end
```

上面不好看，整理下如下：

| 运行顺序 | 脚本                  | 事件          | 时间（秒） | 备注                                                         |
| -------- | --------------------- | ------------- | ---------- | ------------------------------------------------------------ |
| 1        | .asusrouter           |               | 4          | 软件中心进程httpdb启动                                       |
| 2        | init-start            |               | 5          | 原版梅林最早的脚本，软件中心没使用它                         |
| 3        | service-start         | 开始运行      | 18         | 插件：重启助手，ROG工具箱对RAX80风扇的控制由它负责启动       |
| 4        | wan-event             | 0 init        | 18         | wan0开始初始化。wan-event是梅林最近加入的                    |
| 5        | wan-event             | 0 connecting  | 18         | wan0尝试连接                                                 |
| 6        | service-start         | 结束运行      | 20         | 系统服务完毕，软件中心进程skipd应该起来了                    |
| 7        | pre-mount             | /dev/sda ext3 | 21         | USB已经识别，尚未开始挂载                                    |
| 8        | script_usbmount-start |               | 21         | 华硕固件用于自家usb app的启动                                |
| 9        | mount-start           | 开始          | 22         | USB磁盘/dev/sda 格式ext3开始挂载                             |
| 10       | mount-start           | 结束          | 23         | USB磁盘/dev/sda 格式ext3挂载结束                             |
| 11       | wan-event             | 0 connected   | 23         | wan0连上了，不过软件中心还没用这个触发方式                   |
| 12       | wan-start             | 开始          | 23         | wan-event connected和这个效果一样，软件中心多数和网络有关的插件依赖此脚本触发运行 |
| 13       | nat-start             | 开始          | 27         | kp，不可描述等需要nat的插件也会被这个触发                    |
| 14       | nat-start             | 结束          | 42         | 15s才运行玩，日志看nat-start被多次触发，这个和是否pppoe拨号，是否多wan有关 |
| 15       | wan-start             | 结束          | 44         | wan-start脚本运行完毕，和插件数量有关，如果没装插件，这里应该很早就会完成 |

接下来又测试了多个USB磁盘的情况，DHCP上网的情况，最终结果就是post-mount会在service-start之后运行，在wan-start和nat-start之前运行。

所以如果由post-mount触发替换了jffs，那么最好把前面service-start脚本再手动运行一次。

## USB2JFFS自身的开机自启/新USB的插入

这个的实现看似简单，因为就只需要使用到post-mount来触发，开实现用USB挂载jffs，但实际上需要考虑不少。

post-mount脚本并不是只有在开机的时候会触发，路由器运行过程中插入U盘也会触发，每挂载一个分区，post-mount就会运行一次，不过每次运行都带有该分区挂载路径作为$1参数，这方便每次post-mount触发的时候，对改新挂载的设备进行一系列检测：

1. 检测是否已经用USB挂载了jffs，如果是则跳过
2. 如果没有USB挂载jffs，则继续检测该插入U盘是否已经存在.koolshare_jffs目录
3. 如果没有.koolshare_jffs，则跳过
4. 如果有.koolshare_jffs，则继续检测是否有.koolshare_jffs/.usb2jffs_flag文件（）
5. .usb2jffs_flag是用户通过插件卸载USB JFFS时候写入的，这是为了避免用户关掉了jffs的usb挂载，重启路由器又给挂上了
6. 如果有.usb2jffs_flag，则不替换jffs，没有则继续检测
7. 检测是否有usb2jffs_flag这个nvram值，如果有则说明用户用usb挂载了jffs后，没有重置过路由（重置会导致该值消失）
8. 如果没有，则表示用户重置过路由，则需要用原始jffs分区里的nvram文件下里的文件替换掉.koolshare_jffs/nvram/里的文件
9. 继续检测用户上次设定的挂载路径和本次是否一致，因为梅林路由每次重启后，挂载名发生变化太常见了。比如之前是/tmp/mnt/sda1，下次就变成了/tmp/mnt/sdb1。如果变了需要重新记录一次，避免插件页面里显示错误
10. 现在终于可以开始卸载原来的jffs，重新用USB挂载jffs了，中间涉及到软件中心进程的启停
11. 挂载完成后，因为前面提到的原因，还需要触发一次services-start脚本

其实上的过程并不是全部，其中还涉及到jffs原始挂载设备的检测，U盘格式的检测（需要ext格式）等。但总的来说，插件实现了开机自启，并且和软件中心，其它插件的兼容。

## USB磁盘的插入

post-mount脚本并不是只有在开机的时候会触发，路由器运行过程中插入U盘也会触发

1. 系统带着1个USB磁盘启动，post-mount触发1次
2. 系统带着2个USB磁盘启动，post-mount触发2次
3. 1个U盘有多个分区，post-mount触发多次
4. 系统开机得时候本身插着一个U盘，然后又插入一个U盘，，post-mount触发
5. ...

总之就是每挂载一个分区，post-mount就会运行一次，不过每次运行都带有该分区挂载路径作为$1参数，所以当检测到USB插入的时候，需要

1. 检测是否已经用USB挂载了jffs，如果是则跳过
2. 如果没有USB挂载jffs，则继续检测该插入U盘是否已经存在.koolshare_jffs目录
3. 如果没有.koolshare_jffs，则跳过
4. 如果有.koolshare_jffs，则继续检测是否有.koolshare_jffs/.usb2jffs_flag文件（）
5. .usb2jffs_flag是用户通过插件卸载USB JFFS时候写入的，这是为了避免用户关掉了jffs的usb挂载，重启路由器又给挂上了
6. 如果有.usb2jffs_flag，则不替换jffs，没有则继续检测
7. 检测是否有usb2jffs_flag这个nvram值，如果有则说明用户用usb挂载了jffs后，没有重置过路由（重置会导致该值消失）
8. 如果没有，则表示用户重置过路由，则需要用原始jffs分区里的nvram文件下里的文件替换掉.koolshare_jffs/nvram/里的文件
9. 继续检测，挂载路径名是否变化，如果变了需要重新记录一次，避免插件页面里显示错误
10. 现在终于可以开始

## 拔掉USB磁盘

如果我们已经成功创建了USB磁盘挂载jffs，那么这个时候拔掉USB磁盘，会发生什么呢？

其实如果没有替换的情况下，如果有/jffs/scripts/unmount，拔掉USB设备，是会触发/jffs/scripts/unmount这个脚本运行的，并且也带有分区路径参数$1，但是很不幸的是，/jffs是由U盘挂载的，如果拔掉U盘，那么系统是无法访问到/jffs/scripts/unmount这个文件的。

同样，软件中心、插件等文件也是在/jffs里，但是/jffs已经没法访问了，所以拔掉U盘后，再访问软件中心，将会是一片空白。

所以这里友情提醒：请不要在使用USB挂载了jffs后，去拔掉USB磁盘，不仅会让软件中心空白，还有丢失文件的风险！

## 文件同步

需要文件同步吗？

如果用USB磁盘来替换jffs分区，就是为了避免jffs的频繁写入，那么可能确实没必要同步。

如果用USB磁盘来增加jffs容量，安装更多东西，貌似也没必要同步。

软件中心的核心启动部分，还是依靠原始jffs里的文件，如service-start，未来还会有init-start等，如果软件中心更新，如果不同步，这部分相当于没有得到任何更新，这里来看需要同步。

除了一些质量很好的slc U盘，其实普遍U盘耐用度其实不如路由器FLASH的，RT-AC86U的FLASH本身是slc颗粒，为了做到数据非容易还定死了写入和读取速度。U盘要做jffs的话，是要常年挂在路由器的，为了避免U盘down掉软件中心和插件不丢数据，也需要同步。

总之，同步这功能是需要，但是没有那么需要，所以插件默认的同步是12小时进行一次，你也可以根据自己的需求调大时间间隔。也可以根据需要手动进行同步。

现在即使把软件中心所有插件都装完，也不会有任何容量的问题，当然RT-AC86U这种只有48MB的jffs容量的可能会比较告急。但是考虑到未来软件中心还会出很多插件，当有一天USB挂载的jffs占用的空间大于了路由器本身的jffs容量呢？

插件目前的做法是，如果容量没有超过，就全盘同步，同步耗时也不多；如果容量超过了，则只同步系统相关的文件，如证书，流量数据库等。

文件同步的前提是，比如RT-AC86U，最开始/dev/mtdblock8挂载在/jffs，后来是USB磁盘：/dev/sda1挂载在/jffs上，那么需要用另一个目录来给/dev/mtdblock8挂载，USB2JFFS的做法是将/dev/mtdblock8挂载在/cifs2上。华硕、梅林固件这两个文件夹本身是用于挂载远端/网络硬盘的，但是这两个文件夹的使用率非常低，所以用/dev/mtdblock8挂载在/cifs2上。这样同步文件的时候，从设备上说是/dev/sda1 → /dev/mtdblock8，从路径上来说就是/jffs → /cifs2了。=

## 性能如何

- 在创建挂载时，USB2JFFS插件会对USB磁盘进行简单的读写速度测试。  
-  因为测试文件块较小，此测试速度和USB磁盘实际速度可能有一定差别，因此本插件的读写速度结果仅供参考。   
- 在同等测试条件下，RT-AC86U, RT-AX88U, GT-AC5300等机型的flash读为10MB/s, 写为30MB/s。   
- 如果你的USB磁盘读写速度较低，使用本插件将会得到更差的实际体验！ 
- 因此，USB2JFFS插件要求USB磁盘设备读取不低于30MB/s, 写入速度不低于为50MB/s。

关于读写速度的测试结果，仅仅只能作为参考，因为这个读写速度肯定会和你使用PC软件测出来的有较大的差别。考虑到一些很差的USB磁盘，连续写入100MB，都要花上几十秒，使得插件日志要很久很久才会出结果，这是无法忍受的。所以测试读写均是在50MB文件的连续读写上进行的，没有什么4K读写的测试。不过我对RT-AC86U，RT-AX88U，RAX80，GT-AC5300的原始jffs，进行了同样的50M数据连续读写，其结果是惊人的一致：读10MB/s，写30M/s，猜测一方面厂商采用的flash芯片就是这速度，第二方面为了保证路由器flash数据的非易失性，将读写速度规定到这个样子。

总之，USB挂载jffs如果速度还低于这个速度，自然是不像话了。如果U盘性能太差，当然是不建议使用本插件的。为了使用了插件本身能带来较好的体验，所以插件才规定了读30MB/s，写50MB/s的最低值，但是这个值目前是根据前面对路由flash读写速度和我自己有的几个USB磁盘的速写速度综合表现规定的，不一定有参考价值，未来会针对用户的反馈，将这个值进行一些改动。不过肯定不会低于路由FLASH的读写速度。
