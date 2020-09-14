## CFE工具箱

1. CFE工具箱可以检测如硬件版本，主板型号，生产日期，MAC地址，机器地区代码等。
2. CFE工具箱可以修改路由器的地区代码，可以将比如`美版/欧版/日版/亚太版/澳洲版`等各种版本的机器改为`国行`。

## 安装方法

### 1. 软件中心版本【CFE工具箱】

如果你使用的是带软件中心的固件，如`koolshare 华硕官改固件`，`koolshare梅林改版固件`，你可以下载【CFE工具箱】离线安装包：[下载地址1（国内镜像）](https://rogsoft.ddnsto.com/cfetool/cfetool.tar.gz)，[下载地址2（Github镜像）](https://github.com/koolshare/rogsoft/blob/master/cfetool/cfetool.tar.gz)，然后在软件中心的离线安装标签页内进行离线安装。

### 2. 一键脚本版本【CFE工具箱】

如果你使用的固件没有软件中心，比如：`华硕官方固件`、`梅林原版固件`，你可以使用以下一键命令安装CFE工具箱，安装完成后CFE工具箱会出现在路由器后台的侧边栏中。

   ```bash
# 安装CFE工具箱
curl -4sSL https://rogsoft.ddnsto.com/softcenter/ks_cfetool_setup.sh|sh

# 卸载CFE工具箱
/koolshare/bin/ks_cfetool_setup uninstall
   ```

## 机型支持

### 1. 软件中心版本

只要是华硕的以下机型，如果安装了支持koolshare软件中心的固件，均可以使用`软件中心版本`的`CFE工具箱`

| 机型支持                                                  | 固件类型 | CPU/SOC | 平台       |
| --------------------------------------------------------- | -------- | ------- | ---------- |
| [RT-AC86U](http://koolshare.cn/thread-127878-1-1.html)    | ML改     | BCM4906 | hnd        |
| [RT-AC86U](http://koolshare.cn/thread-139965-1-1.html)    | 官改     | BCM4906 | hnd        |
| [GT-AC5300](http://koolshare.cn/thread-130902-1-1.html)   | 官改     | BCM4908 | hnd        |
| [RT-AX88U](http://koolshare.cn/thread-158199-1-1.html)    | ML改     | BCM4908 | axhnd      |
| [GT-AX11000](http://koolshare.cn/thread-159465-1-1.html)  | 官改     | BCM4908 | axhnd      |
| [RT-AX86U](https://koolshare.cn/thread-181845-1-1.html)   | 官改     | BCM4908 | axhnd.675x |
| [RT-AX82U](https://koolshare.cn/thread-xxxxxx-1-1.html)   | 官改     | BCM6750 | axhnd.675x |
| [TUF-AX3000](https://koolshare.cn/thread-179968-1-1.html) | 官改     | BCM6750 | axhnd.675x |

### 2. 一键脚本版本

- 一键脚本版本的CFE工具箱仅支持`华硕官方固件`、`梅林原版固件`，不支持带软件中心的固件
- 华硕官方固件不论是384还是386版本均支持

| 机型支持                         | 固件类型                  | CPU/SOC | 平台       |
| -------------------------------- | ------------------------- | ------- | ---------- |
| RT-AC86U                         | 华硕官方固件/梅林原版固件 | BCM4906 | hnd        |
| RT-AC2900                        | 华硕官方固件              | BCM4906 | hnd        |
| GT-AC2900                        | 华硕官方固件              | BCM4906 | hnd        |
| GT-AC5300                        | 华硕官方固件              | BCM4908 | hnd        |
| GT-AX11000                       | 华硕官方固件              | BCM4908 | axhnd      |
| RT-AX88U                         | 华硕官方固件/梅林原版固件 | BCM4908 | axhnd      |
| RT-AX92U                         | 华硕官方固件              | BCM4906 | axhnd      |
| RT-AX56U                         | 华硕官方固件/梅林原版固件 | BCM6755 | axhnd.675x |
| RT-AX58U                         | 华硕官方固件/梅林原版固件 | BCM6750 | axhnd.675x |
| RT-AX82U                         | 华硕官方固件              | BCM6750 | axhnd.675x |
| RT-AX86U                         | 华硕官方固件              | BCM4908 | axhnd.675x |
| RT-AX3000                        | 华硕官方固件/梅林原版固件 | BCM6750 | axhnd.675x |
| TUF-AX3000                       | 华硕官方固件              | BCM6750 | axhnd.675x |
| ZenWiFi AX/灵耀 AX6600M/RT-AX95Q | 华硕官方固件              | BCM6755 | axhnd.675x |

### 3. 其它说明

网件RAX80，虽然是axhnd机型，但是其梅林固件属于移植固件，并且其bootloader和cfe使用的网件的而不是华硕的，因此不支持CFE工具箱。

老的ARMv7机型比如RT-AC68U、RT-AC88U、RT-AC5300等，目前暂不支持CFE工具箱，不过针对这些机型目前已经有现成的修改CFE教程教程：

- SDK4708，适用于RT-AC68U: https://koolshare.cn/thread-3557-1-1.html

- SDK7/SDK7114，适用于RT-AC88U、RT-AC3100、RT-AC5300: https://koolshare.cn/thread-175962-1-1.html。

## 注意事项

- 本插件通过修改底层CFE来实现修改路由器国家地区，须知修改CFE有风险，由此带来的风险请自行承担！
- 改国行后，卸载本插件、重置路由器、升级固件、刷三方固件/原厂固件等操作，只要不损坏CFE分区，机器均会保持国行状态。

## FAQ

1. **路由器改国行有什么作用？**

   答：华硕路由器通过地区代码来限制固件功能，如`wifi选区澳大利亚`，`UU加速器`，`中文语言显示`等，改CFE为国区后这些功能将不会再受到限制。事实上，除了保修政策以外，你的机器在软件硬件各方面已经是一台不折不扣的国行机器了。
   
2. **怎么知道改国行成功没有？**

   答：改完后再次运行CFE工具箱，点击`开始检测`按钮，即可检测是否已经改成国行。也可以前往【无线网络】- 【专业设置】里查看wifi改区中是否出现澳大利亚。

   一般来说，成功改国行后只需要重启路由器就能起作用，但是可能某些日版或者其他版本的机器改了国行重启后无法立即看到效果，这个时候需要手动重置一次路由器，才能让固件工作在国行的状态。

3. **我想增强信号，改国行后还有必要购买wifi boost吗？**

   答：一般来说没必要，改国行后最大的变化就是wifi区域支持澳大利亚，而澳大利亚提供了很强的无线发射功率，比如国行RT-AX88U的澳大利亚发射功率高达26dbm，即316毫瓦，其它机器的澳大利亚地区无线功率请见下方附件表格。如果国行的澳大利亚地区都无法提供足够的信号覆盖，再考虑购买wifi boost。

4. **改国行后，以后升级固件了，是不是也要激活下这个工具箱搞一下**

   答：不用的，本插件改国行是改一次一劳永逸。以后你重置、双清、刷机等操作均不会影响，机器会一直保持国行状态。除非你再次用本插件恢复原始CFE。

5. **GT-AX11000改国行后，第二个5G无法160MHz了**

   答：这是肯定的，因为正常国行机器的第二个5G都没法使用160Mhz。

6. **我重置了路由器，软件中心找不到【CFE工具箱】插件了**

    答：可能是下架了，但是你可以下载【CFE工具箱】离线安装包：[下载地址1](https://rogsoft.ddnsto.com/cfetool/cfetool.tar.gz)，[下载地址2](https://github.com/koolshare/rogsoft/blob/master/cfetool/cfetool.tar.gz)，或者邮件询问mjy211@gmail.com获得离线安装包。

7. **我有多台非国行的路由器，激活码是否支持激活多台机器？**

    答：不能，CFE工具箱激活码为一机一码。

8. **我遗失了我的激活码，怎么找回**

    答：一般来说重装插件就能自动找回，如果还是不行，请发机器码到mjy211@gmail.com找回。

## 附件

### 1. 各个机型澳大利亚地区无线功率表

| 机型       | 2.4G              | 5G/5G-1           | 5G-2             |
| ---------- | ----------------- | ----------------- | ---------------- |
| RT-AC86U   | 25 dBm / 316.2 mw | 25 dBm / 316.2 mw | /                |
| GT-AC5300  | 24 dBm / 251.2 mw | 24 dBm / 251.2 mw | 24dBm / 251.2 mw |
| RT-AX88U   | 26 dBm / 398.1 mw | 26 dBm / 398.1 mw | /                |
| GT-AX11000 | 24 dBm / 251.2 mw | 24 dBm / 251.2 mw | 24dBm / 251.2 mw |
| RT-AX86U   | 26 dBm / 398.1 mw | 26 dBm / 398.1 mw | /                |
| RT-AX92U   | 25 dBm / 316.2 mw | 25 dBm / 316.2 mw | 25dBm / 316.2 mw |
| TUF-AX3000 | 27 dBm / 501.2 mw | 26 dBm / 398.1 mw | /                |

### 2. CFE工具箱支持的固件/机型

只要是华硕的以下机型，如果安装了支持koolshare软件中心的固件，均可以CFE工具箱来实现改国行功能。

- **hnd平台机型：** `RT-AC86U`  `GT-AC5300`
- **axhnd平台机型：**`RT-AX88U`  `GT-AX11000` `GT-AX11000_BO4`
- **axhnd.675x平台机型：**`RT-AX86U` `TUF-AX3000`  `RT-AX82U`

如果是使用官方或者梅林原版固件的，建议可以先刷机成koolshare固件后，使用CFE工具箱改完国行，再刷回原来的固件。

网件 RAX80 梅林固件，其属于移植固件，它的CFE是使用的网件原厂的，所以是不支持CFE工具箱插件的。

GT-AC2900、RT-AX92U等没有koolshare改版固件的机型，目前还无法使用CFE工具箱，因为其没有koolshare改版固件。

