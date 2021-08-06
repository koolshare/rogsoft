#  **rogsoft**

> rogsoft软件中心基于kollshare开发的1.5代软件中心，适用于`koolshare 梅林改/官改 hnd/axhnd/axhnd.675x`固件平台，其与梅林arm380/arm384 一代软件中心不兼容！

## 机型支持

### koolshare官改固件

> koolshare官改固件是从华硕对应机型的源代码修改而来，目的是为了在尽量保持ASUS官方固件原汁原味的基础上，增加软件中心及对应插件的支持。目前koolshare 官改固件支持以下机型：

| 机型/固件下载                                                | CPU/SOC | 平台         | 架构  | 内核   | 皮肤                |
| ------------------------------------------------------------ | ------- | ------------ | ----- | ------ | ------------------- |
| [RT-AC86U](http://koolshare.cn/thread-139965-1-1.html)       | BCM4906 | hnd          | ARMV8 | 4.1.27 | rog/asuswrt **[1]** |
| [GT-AC5300](http://koolshare.cn/thread-130902-1-1.html)      | BCM4908 | hnd          | ARMV8 | 4.1.27 | rog  (红色)         |
| [GT-AX11000/GT-AX11000_BO4](http://koolshare.cn/thread-159465-1-1.html) | BCM4908 | axhnd        | ARMV8 | 4.1.51 | rog  (红色)         |
| [RT-AX92U](https://koolshare.cn/thread-191634-1-1.html)      | BCM4906 | axhnd        | ARMV8 | 4.1.51 | asuswrt             |
| [RT-AX86U/RT-AX86U高达版](https://koolshare.cn/thread-181845-1-1.html) | BCM4908 | p1axhnd.675x | ARMV8 | 4.1.52 | asuswrt             |
| [TUF-AX3000/TUF-AX3000刺客信条版](https://koolshare.cn/thread-179968-1-1.html) | BCM6750 | axhnd.675x   | ARMV7 | 4.1.52 | tuf（橙色）         |
| [RT-AX82U/RT-AX82U高达版](https://koolshare.cn/thread-xxxxxx-1-1.html) | BCM6750 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt             |
| [ZenWiFi AX6600/灵耀 AX6600M](https://koolshare.cn/thread-187704-1-1.html) | BCM6755 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt             |
| [ZenWiFi_XD4/灵耀AX魔方](https://koolshare.cn/thread-187744-1-1.html) | BCM6755 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt             |
| [RT-AX56U青春/热血/刺客信条版](https://koolshare.cn/thread-188683-1-1.html) | BCM6755 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt             |
| [RT-AX68U](https://koolshare.cn/thread-191640-1-1.html)      | BCM4906 | p1axhnd.675x | ARMV8 | 4.1.52 | asuswrt             |

- 点击表格中的机型可以前往对应机型的koolshare固件下载；
- RT-AX56U_V2/RT-AX56U青春版/RT-AX56U热血版/RT-AX56U刺客信条版，这四个名字代表一个机型。
- **[1]**：RT-AC86U从384_81918_koolshare固件版本开始，使用的是asuswrt风格ui，而不是rog风格。

### koolshare梅林改版固件

> koolshare梅林改版固件是基于加拿大独立开发者Eric Sauvageau的华硕路由器

| 机型/固件下载                                                | CPU/SOC | 平台         | 架构  | 内核   | 皮肤    |
| ------------------------------------------------------------ | ------- | ------------ | ----- | ------ | ------- |
| [RT-AC86U](http://koolshare.cn/thread-127878-1-1.html)       | BCM4906 | hnd          | ARMV8 | 4.1.27 | asuswrt |
| [GT-AC2900](https://koolshare.cn/thread-191639-1-1.html)     | BCM4906 | hnd          | ARMV8 | 4.1.27 | asuswrt |
| [RT-AX88U](http://koolshare.cn/thread-158199-1-1.html)       | BCM4908 | axhnd        | ARMV8 | 4.1.51 | asuswrt |
| [NETGEAR RAX80](https://koolshare.cn/thread-177255-1-1.html) | BCM4908 | axhnd        | ARMV8 | 4.1.51 | asuswrt |
| [GT-AX11000/GT-AX11000_BO4](https://koolshare.cn/thread-194094-1-1.html) | BCM4908 | axhnd        | ARMV8 | 4.1.51 | asuswrt |
| [RT-AX68U](https://koolshare.cn/thread-194116-1-1.html)      | BCM4906 | p1axhnd.675x | ARMV8 | 4.1.52 | asuswrt |
| [RT-AX86U/RT-AX86U高达版](https://koolshare.cn/thread-191637-1-1.html) | BCM4908 | p1axhnd.675x | ARMV8 | 4.1.52 | asuswrt |
| [RT-AX56U](https://koolshare.cn/thread-192282-1-1.html)      | BCM6755 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt |
| [RT-AX58U](https://koolshare.cn/thread-194117-1-1.html)      | BCM6755 | axhnd.675x   | ARMV7 | 4.1.52 | asuswrt |

## 用户须知

- 本项目，即[hnd软件中心（rogsoft）](hnd/axhnd软件中心（rogsoft）)与梅林[arm380](https://github.com/koolshare/koolshare.github.io)、[arm384/arm386](https://github.com/koolshare/armsoft)软件中心的插件不兼容！所以不要用离线安装功能安装其它平台的软件中心！！
- 除非你要安装的插件作者明确表示他的插件可以用于hnd/axhnd/axhnd.675x/p1axhnd.675x平台的软件中心，或者插件来源于rogsoft内本身的插件，才可以安装！！

## 开发须知：

如果你是开发者，想要为rogsoft开发新的插件，并用离线包的方式进行传播，请了解rogsoft是基于koolshare 1.5代软件中心api开发，其和前代梅林380软件中心不同，并且不兼容（因为web api）！：

1. 在web方面：此版软件中心在web上使用的是软件中心1.5代的api，与[ledesoft](https://github.com/koolshare/ledesoft)、[armsoft](https://github.com/koolshare/armsoft)和[qcasoft](https://github.com/koolshare/qcasoft)一致
2. 在程序方面：armv8架构机器的hnd/axhnd平台支持32+64位程序，armv7l架构机器的axhnd.675x平台仅支持32位程序。所以为了兼容所有机型，建议全部采用32位程序；即使是hnd/axhnd平台机型，比如RT-AX86U，其内核虽然是64位的，但是其userspace程序几乎都是32位的。
3. 程序编译建议使用博通SDK中提供的工具链：[官方工具链](https://github.com/RMerl/am-toolchains/tree/master/brcm-arm-hnd)，使用arm工具链编译32位程序，并且为了保证在不同固件之间的正常运行，尽量使用全静态编译。
4. hnd平台二进制编译使用：**crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25**，axhnd平台二进制编译使用：**crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1**，不过一般来说不论使用哪个工具链，编译出来的二进制都能在两个平台上同时使用。
5. 因为rogsoft同时支持了多种不同皮肤的固件（普通的asuswrt皮肤，红色的rog皮肤，橙色的tuf皮肤），所以插件的制作需要考虑到多个不同风格的UI，建议可以用css或者定制不同的asp文件，但是后台脚本而二进制保持一致，也可以参考软件中心aliddns插件的作法，先判断固件需要的UI类型：https://github.com/koolshare/rogsoft/blob/master/aliddns/aliddns/install.sh#L51-L88，再在安装的时候更改不同css来控制UI：https://github.com/koolshare/rogsoft/blob/master/aliddns/aliddns/install.sh#L108-L124，当然，前提是asp、css文件预先留好匹配字段（本例中为`/* W3C rogcss */`）：https://github.com/koolshare/rogsoft/blob/master/aliddns/aliddns/webs/Module_aliddns.asp#L37-L38。tuf橙色皮肤采用rog皮肤为基础，通过颜色替换而来，所以在写rog UI的时候，请保证能将红色替换为橙色，以保证tuf皮肤正常。
6. 为了避免用户使用其它平台的离线安装包进行安装，因此，rogsoft软件中心需要对离线安装包需要做验证。安装时需要验证安装包内是否含有`.valid`文件，且文件内含有`hnd`字符串。
7. 为了避免用户将本项目内的离线安装包用于其它不兼容的软件中心平台，而这些平台的软件中心有可能版本较老没有`.valid`检查，因此本项目中所有的安装包内的`install.sh`都需要进对安装的固件/平台进行检测：https://github.com/koolshare/rogsoft/blob/master/aliddns/aliddns/install.sh#L42-L49。

## **koolshare几个版本的软件中心区别：**

|  软件中心   |                        arm380软件中心                        |                      arm384/386软件中心                      |                     hnd软件中心(本项目)                      | qca软件中心                                                  |                    软路由-酷软                    |
| :---------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | ------------------------------------------------------------ | :-----------------------------------------------: |
|  项目名称   | [koolshare.github.io](https://github.com/koolshare/koolshare.github.io) |       [armsoft](https://github.com/koolshare/armsoft)        |       [rogsoft](https://github.com/koolshare/rogsoft)        | [qcasoft](https://github.com/koolshare/qcasoft)              | [ledesoft](https://github.com/koolshare/ledesoft) |
|  适用架构   |                            armv7l                            |                            armv7l                            |                         armv7l/armv8                         | armv7l                                                       |                        x64                        |
|    平台     |                             arm                              |                             arm                              |                          hnd/axhnd                           | qca-ipq806x                                                  |                     by fw867                      |
|  linux内核  |                           2.6.36.4                           |                           2.6.36.4                           |                            4.1.xx                            | 4.4.60                                                       |                       很新                        |
|     CPU     |                          bcm4708/9                           |                          bcm4708/9                           |                       bcm490x/bcm67xx                        | IPQ807x                                                      |                     intel/AMD                     |
|  固件版本   |                        ks梅林**380**                         |                      ks梅林**384**/386                       |                     koolshare 梅林/官改                      | koolshare 官改                                               |                   OpenWRT/LEDE                    |
| 软件中心api |                          **1.0** 代                          |                          **1.5** 代                          |                          **1.5** 代                          | **1.5** 代                                                   |                    **1.5** 代                     |
| 代表机型-1  | [RT-AC68U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC88U 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [RT-AC86U 改版梅林](https://koolshare.cn/thread-127878-1-1.html) | [RT-AX89X 官改固件](https://koolshare.cn/thread-188090-1-1.html) |                         \                         |
| 代表机型-2  | [RT-AC88U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) | [RT-AC5300 改版梅林384](https://koolshare.cn/thread-164857-1-1.html) | [GT-AC5300 华硕官改](https://koolshare.cn/thread-130902-1-1.html) |                                                              |                         \                         |
| 代表机型-3  | [R7000 改版梅林380](https://koolshare.cn/thread-139324-1-1.html) |                                                              | [RT-AX88U 改版梅林](https://koolshare.cn/thread-158199-1-1.html) |                                                              |                         \                         |

