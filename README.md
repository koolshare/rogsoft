#  **rogsoft**

> rogsoft软件中心基于kollshare开发的1.5代软件中心，适用于`koolshare 梅林改/官改 hnd/axhnd/axhnd.675x`固件平台，其与梅林arm380/arm384 一代软件中心不兼容！

## 机型支持

| 机型/固件下载                                                | 类型   | CPU/SOC | 平台       | CPU     | 架构  | 内核   | 皮肤        |
| ------------------------------------------------------------ | ------ | ------- | ---------- | ------- | ----- | ------ | ----------- |
| [RT-AC86U](http://koolshare.cn/thread-127878-1-1.html)       | 梅林改 | BCM4906 | hnd        | BCM4906 | ARMV8 | 4.1.27 | asuswrt     |
| [RT-AX88U](http://koolshare.cn/thread-158199-1-1.html)       | 梅林改 | BCM4908 | axhnd      | BCM4908 | ARMV8 | 4.1.51 | asuswrt     |
| [NETGEAR RAX80](https://koolshare.cn/thread-177255-1-1.html) | 梅林改 | BCM4908 | axhnd      | BCM4908 | ARMV8 | 4.1.51 | asuswrt     |
| [RT-AC86U](http://koolshare.cn/thread-139965-1-1.html)       | 官改   | BCM4906 | hnd        | BCM4906 | ARMV8 | 4.1.27 | rog  (红色) |
| [GT-AC5300](http://koolshare.cn/thread-130902-1-1.html)      | 官改   | BCM4908 | hnd        | BCM4908 | ARMV8 | 4.1.27 | rog  (红色) |
| [GT-AX11000](http://koolshare.cn/thread-159465-1-1.html)     | 官改   | BCM4908 | axhnd      | BCM4908 | ARMV8 | 4.1.51 | rog  (红色) |
| [TUF-AX3000](https://koolshare.cn/thread-179968-1-1.html)    | 官改   | BCM6750 | axhnd.675x | BCM6750 | ARMV7 | 4.1.52 | tuf（橙色） |
| [RT-AX86U](https://koolshare.cn/thread-181845-1-1.html)      | 官改   | BCM4908 | axhnd.675x | BCM4908 | ARMV8 | 4.1.52 | asuswrt     |
| [RT-AX82U](https://koolshare.cn/thread-xxxxxx-1-1.html)      | 官改   | BCM6750 | axhnd.675x | BCM6750 | ARMV7 | 4.1.52 | asuswrt     |

- 点击表格中的机型可以前往对应机型的koolshare固件下载。

- rogsfot软件中心支持的新机型支持将不断添加，请关注本项目。

## 用户须知

- 本项目，即[hnd软件中心（rogsoft）](hnd/axhnd软件中心（rogsoft）)与梅林[arm380](https://github.com/koolshare/koolshare.github.io)/[arm384](https://github.com/koolshare/armsoft)软件中心的插件不兼容！所以不要用离线安装功能安装其它平台的软件中心！！
- 除非你要安装的插件作者明确表示他的插件可以用于hnd/axhnd平台的软件中心，或者插件来源于rogsoft内本身的插件，才可以安装！！

## 开发须知：

如果你是开发者，想要为rogsoft开发新的插件，并用离线包的方式进行传播，请了解rogsoft是基于koolshare 1.5代软件中心api开发，其和前代梅林380软件中心不同，并且不兼容（因为web api）！：

1. 在web方面：此版软件中心在web上使用的是软件中心1.5代的api，与[ledesoft](https://github.com/koolshare/ledesoft)和[armsoft](https://github.com/koolshare/armsoft)一致
2. 在程序方面：armv8架构机器的hnd/axhnd平台支持32+64位程序，armv7l架构机器的axhnd.675x平台仅支持32位程序。所以为了兼容所有机型，建议全部采用32位程序；即使是hnd/axhnd平台机型，比如RT-AX86U，其内核虽然是64位的，但是其userspace程序几乎都是32位的。
3. 程序编译建议使用博通SDK中提供的工具链：[官方工具链](https://github.com/RMerl/am-toolchains/tree/master/brcm-arm-hnd)，使用arm工具链编译32位程序，并且为了保证在不同固件之间的正常运行，尽量使用全静态编译。
4. hnd平台二进制编译使用：**crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25**，axhnd平台二进制编译使用：**crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1**，不过一般来说不论使用哪个工具链，编译出来的二进制都能在两个平台上同时使用。
5. 因为rogsoft同时支持了多种不同皮肤的固件（普通的asuswrt皮肤，红色的rog皮肤，橙色的tuf皮肤），所以插件的制作需要考虑到多个不同风格的UI，建议可以用css或者定制不同的asp文件，但是后台脚本而二进制保持一致，也可以参考软件中心插件的作法，先判断固件需要的UI类型：https://github.com/koolshare/rogsoft/blob/master/acme/acme/install.sh#L42-L50，再在安装的时候更改不同css来控制UI：https://github.com/koolshare/rogsoft/blob/master/acme/acme/install.sh#L63-L74，当然，前提是asp、css文件预先留好匹配字段（本例中为`/* W3C rogcss */`）：https://github.com/koolshare/rogsoft/blob/master/acme/acme/webs/Module_acme.asp#L49。tuf橙色皮肤采用rog皮肤为基础，通过颜色替换而来，所以在写rog UI的时候，请保证能将红色替换为橙色，以保证tuf皮肤正常。
6. 为了避免用户使用其它平台的离线安装包进行安装，因此，rogsoft软件中心需要对离线安装包需要做验证。安装时需要验证安装包内是否含有`.valid`文件，且文件内含有`hnd`字符串。
7. 为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，因此本项目中所有的安装包内的`install.sh`都需要进对安装的固件/平台进行检测。

## **koolshare几个版本的软件中心区别：**

|  软件中心   |                        arm380软件中心                        |                        arm384软件中心                        |                     hnd软件中心(本项目)                      |                    软路由-酷软                    |
| :---------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :-----------------------------------------------: |
|  项目名称   | [koolshare.github.io](https://github.com/koolshare/koolshare.github.io) |       [armsoft](https://github.com/koolshare/armsoft)        |       [rogsoft](https://github.com/koolshare/rogsoft)        | [ledesoft](https://github.com/koolshare/ledesoft) |
|  适用架构   |                            armv7l                            |                            armv7l                            |                         armv7l/armv8                         |                        x64                        |
|    平台     |                             arm                              |                             arm                              |                          hnd/axhnd                           |                     by fw867                      |
|  linux内核  |                           2.6.36.4                           |                           2.6.36.4                           |                            4.1.xx                            |                       很新                        |
|     CPU     |                          bcm4708/9                           |                          bcm4708/9                           |                       bcm490x/bcm67xx                        |                     intel/AMD                     |
|  固件版本   |                    koolshare 梅林**380**                     |                    koolshare 梅林**384**                     |                     koolshare 梅林/官改                      |                   OpenWRT/LEDE                    |
| 软件中心api |                          **1.0** 代                          |                          **1.5** 代                          |                          **1.5** 代                          |                    **1.5** 代                     |
| 代表机型-1  | [RT-AC68U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC88U 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [RT-AC86U 改版梅林](https://koolshare.cn/thread-127878-1-1.html) |                         \                         |
| 代表机型-2  | [RT-AC88U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC5300 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [GT-AC5300 华硕官改](https://koolshare.cn/thread-130902-1-1.html) |                         \                         |
| 代表机型-3  | [R7000 改版梅林380](https://koolshare.cn/thread-139324-1-1.html) |                                                              | [RT-AX88U 改版梅林](https://koolshare.cn/thread-158199-1-1.html) |                         \                         |
