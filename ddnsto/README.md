# DDNSTO 华硕 / 梅林软件中心插件

本目录提供 DDNSTO 客户端、软件中心管理页面和安装 / 启停脚本的打包入口。
构建只封装 `ddnsto/` 内已有文件，不编译或下载客户端，也不上传 CDN。

## 多平台构建

在仓库根目录执行；需要 POSIX shell、tar、gzip、mktemp 和 Python 3（标准库即可）：

| 渠道 | 构建命令 | 包内 `.valid` |
| --- | --- | --- |
| rogsoft | `sh ddnsto/build_hnd.sh` | `hnd` |
| mtksoft | `sh ddnsto/build_mtk.sh` | `mtk` |
| ipq32soft | `sh ddnsto/build_ipq32.sh` | `ipq32` |
| ipq64soft | `sh ddnsto/build_ipq64.sh` | `ipq64` |
| qcasoft | `sh ddnsto/build_qca.sh` | `qca` |

也可以直接执行 `sh ddnsto/build.sh mtk`。无参数的 `sh ddnsto/build.sh`
保留历史行为，默认构建 HND 包。未知平台（包括 `armsoft`）和多余参数会报错。
旧 Linux 2.6 平台的 armsoft 属于独立项目，不在本构建矩阵中。

每个平台保留 `bin/ddnsto_arm` 和 `bin/ddnsto_aarch64`，安装脚本继续根据
路由器 `uname -m` 选择实际二进制。缺少、为空或不可执行的二进制会使构建失败。
打包在临时目录写入 `.valid` 和版本，不修改源目录中的平台标记、版本或二进制。

## 产物与发布衔接

为兼容软件中心现有插件约定，每次构建生成 / 更新：

- `ddnsto/ddnsto.tar.gz`：顶层目录为 `ddnsto/` 的插件包。
- `ddnsto/version`：插件版本和压缩包 MD5。
- `ddnsto/config.json.js`：插件元数据，包含对应压缩包 MD5。
- `softcenter/app.json.js`：由现有 `gen_install.py stage2` 更新的软件中心索引。

各平台输出文件同名，必须串行构建，并在下一次构建前保存当前平台产物。
例如从仓库根目录生成五个平台的独立目录：

```sh
set -e
output_dir=$(mktemp -d /tmp/ddnsto-packages.XXXXXX)
for platform in hnd mtk ipq32 ipq64 qca; do
    case "$platform" in
        hnd) channel=rogsoft ;;
        *) channel="${platform}soft" ;;
    esac
    sh "ddnsto/build_${platform}.sh"
    mkdir -p "$output_dir/$channel/ddnsto"
    cp ddnsto/ddnsto.tar.gz ddnsto/version ddnsto/config.json.js \
        "$output_dir/$channel/ddnsto/"
done
echo "$output_dir"
```

上述命令只保存 DDNSTO 包及其元数据。整个渠道的软件中心索引应在该渠道的插件
筛选和构建完成后统一生成、发布，不能将本地全仓库索引直接当作各渠道正式索引。
CDN 上传和线上发布由外层部署流程负责。

## 验证

```sh
python3 -m unittest discover -s ddnsto/tests -v
```

测试在临时工作区运行真实打包及索引生成，覆盖五个平台入口、默认 HND 行为、
显式平台参数、含空格路径、包内文件 / 双架构二进制 / 执行权限、版本与 MD5、
源文件保持不变，以及非法参数和缺失二进制时保留已有产物。
测试不会执行路由器二进制；安装、连接和文件访问仍需对应机型真机验证。
