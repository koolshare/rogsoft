#  rogsoft

> rogsoft是基于梅林hnd/axhnd平台路由器的软件中心，其与梅林arm380/arm380软件中心的插件不兼容！rogsoft仅适用于koolshare 梅林/官改平台，且linux内核为4.1.27/4.1.51的armv8架构（aarch64）的路由器！
> 

## 机型兼容

使用rogsoft软件中心，必须满足机型和固件两个要求：

1. 机型必须是架构为armv8（aarch64），linux内核4.1.27/4.1.51的，为asuswrt/merlin hnd/axhnd平台的，例如以下机型都是这种架构的机型，因为他们都使用了博通bcm4906/8这种CPU。
   1. 华硕hnd：`RT-AC86U` `GT-AC5300` `GT-AC2900`
   2. 华硕axhnd：`RT-AX88U` `GT-AX11000` 
   3. 网件：`R8000P`
2. 这些机器必须使用koolshare 梅林/官改固件！即使第1项条件满足，但是如果koolshare开发组没有推出该机型的梅林/官改改版固件，那么本软件中心也无法支持，比如`GT-AC2900` `R8000P`等。
3. 目前支持**rogsoft**的机型/固件：

    * [RT-AC86U merlin改版固件](http://koolshare.cn/thread-127878-1-1.html)
    * [RT-AX88U merlin改版固件](http://koolshare.cn/thread-158199-1-1.html)
    * [RT-AC86U 官改固件](http://koolshare.cn/thread-139965-1-1.html)
    * [GT-AC5300 官改固件](http://koolshare.cn/thread-130902-1-1.html)
    * [GT-AX11000 官改固件](http://koolshare.cn/thread-159465-1-1.html)
    * [NETGEAR RAX80 梅林改版固件](https://koolshare.cn/thread-177255-1-1.html)

## 用户须知

- 本项目，即[hnd/axhnd软件中心（rogsoft）](hnd/axhnd软件中心（rogsoft）)与梅林[arm380](https://github.com/koolshare/koolshare.github.io)/[arm384](https://github.com/koolshare/armsoft)软件中心的插件不兼容！所以不要用离线安装功能安装其它平台的软件中心！！
- 除非你要安装的插件作者明确表示他的插件可以用于hnd/axhnd平台的软件中心，或者插件来源于rogsoft内本身的插件，才可以安装！！

## 开发须知：

如果你是开发者，想要为rogsoft开发新的插件，并用离线包的方式进行传播，请了解rogsoft是基于koolshare 1.5代软件中心api开发，其和前代梅林380软件中心不同，并且不兼容（因为web api）！：

1. 在web方面：此版软件中心在web上使用的是软件中心1.5代的api，与[ledesoft](https://github.com/koolshare/ledesoft)和[armsoft](https://github.com/koolshare/armsoft)一致
2. 在程序方面：由于固件采用了版本为4.1.27/4.1.51的linux内核，和armv8的编译器，所以请确保你编译的程序是armv8架构的。或者可以使用[hnd/axhnd平台官方工具链](https://github.com/RMerl/am-toolchains/tree/master/brcm-arm-hnd)机型编译。
3. 使用[hnd/axhnd平台官方工具链](https://github.com/RMerl/am-toolchains/tree/master/brcm-arm-hnd)编译二进制程序，建议使用32位的工具链编译32位的程序，因为hnd/axhnd平台的这些机器都是使用的64位内核（kernel），和32位的用户空间（userspace），当然编译64位程序也是能够正常运行的，不过可能消耗更多的路由器ram
4. hnd平台二进制编译使用：**crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25**，axhnd平台二进制编译使用：**crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1**，不过一般来说不论使用哪个工具链，编译出来的二进制都能在两个平台上同时使用。
5. 因为rogsoft同时支持了梅林改版和官改两种不同皮肤的固件，所以插件的制作需要考虑到两个不同风格的UI，建议可以用css或者定制不同的asp文件，但是后台脚本而二进制保持一致。
6. 为了避免用户使用其它平台的离线安装包进行安装，因此，rogsoft软件中心需要对离线安装包需要做验证。安装时需要验证安装包内是否含有`.valid`文件，且文件内含有`hnd`字符串。
7. 为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，为了避免用户讲本项目内的离线安装包用于其它不兼容的软件中心平台，因此本项目中所有的安装包内的`install.sh`都需要进对安装的固件/平台进行检测。

## **koolshare几个版本的软件中心区别：**

|  软件中心   |                        arm380软件中心                        |                 arm384软件中心                  |                      hnd/axhnd软件中心                       |                    软路由-酷软                    |
| :---------: | :----------------------------------------------------------: | :---------------------------------------------: | :----------------------------------------------------------: | :-----------------------------------------------: |
|  项目名称   | [koolshare.github.io](https://github.com/koolshare/koolshare.github.io) | [armsoft](https://github.com/koolshare/armsoft) |       [rogsoft](https://github.com/koolshare/rogsoft)        | [ledesoft](https://github.com/koolshare/ledesoft) |
|  适用架构   |                            armv7l                            |                     armv7l                      |                       armv8（aarch64）                       |                        x64                        |
|    平台     |                             arm                              |                       arm                       |                          hnd/axhnd                           |                     by fw867                      |
|  linux内核  |                           2.6.36.4                           |                    2.6.36.4                     |                        4.1.27/4.1.51                         |                       很新                        |
|     CPU     |                          bcm4708/9                           |                    bcm4708/9                    |                          bcm4906/8                           |                     intel/AMD                     |
|  固件版本   |                    koolshare 梅林**380**                     |              koolshare 梅林**384**              |                     koolshare 梅林/官改                      |                   OpenWRT/LEDE                    |
| 软件中心api |                          **1.0** 代                          |                   **1.5** 代                    |                          **1.5** 代                          |                    **1.5** 代                     |
| 代表机型-1  | [RT-AC68U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) |              RT-AC88U 改版梅林384               | [RT-AC86U 改版梅林](https://koolshare.cn/thread-127878-1-1.html) |                         \                         |
| 代表机型-2  | [RT-AC88U 改版梅林380](https://koolshare.cn/thread-139322-1-1.html) |              RT-AC5300 改版梅林384              | [GT-AC5300 华硕官改](https://koolshare.cn/thread-130902-1-1.html) |                         \                         |
| 代表机型-3  | [R7000 改版梅林380](https://koolshare.cn/thread-139324-1-1.html) |                                                 | [RT-AX88U 改版梅林](https://koolshare.cn/thread-158199-1-1.html) |                         \                         |


