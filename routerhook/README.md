# RouterHook通知回调插件

路由器端的WebHook插件，方便路由器将消息通知回调到你配置的URL。

[反馈地址](https://koolshare.cn/thread-178114-1-1.html)

[更新日志](https://raw.githubusercontent.com/koolshare/rogsoft/master/routerhook/Changelog.txt)

![](./res/webhook.png)

> 感谢[ServerChan插件](https://koolshare.cn/forum.php?mod=viewthread&tid=123937&highlight=serverchan)作者，本插件基本都是在ServerChan插件基础上进行修改的。ServerChan是为程序员和服务器之间通信的插件，那么本插件可以说就是为路由器和服务器之间通信的插件。至于服务器上的逻辑，需要你自己实现，比如可以通过钉钉机器人、企业微信机器人、ServerChan、HomeAssistant等等实现更丰富的自定义消息处理逻辑。

## 缘起

身为一个资(zhuang)深(bi)程序员，ServerChan显然是满足不了我的要求的。因为ServerChan只是提供了一个通知推送的工具，但是如果我想用企业微信机器人呢？ServerChan显然满足不了要求哇。其实ServerChan还有一款可以进行【1对多】推送的`PushBear`和具有【双向交互】功能的`TalkAdmin`产品，都灰常好用！但毕竟这样支持的平台削微单一，不是那么有普适性，单独为他们开发插件远远超出了我的能力范围。为了方便同行们可以用自己熟悉的语言和环境，与路由器之间可以更进一步的交流（资深程序员不一定有空开发路由器插件不是），这个插件就诞生啦！不过说白了这个插件还是只是一个单向推送，没有实现被回调（貌似固件有WebAPI？没研究过，那个也超出了我的能力范围，暂时不管了）

- 这是我滴第一个作品，第一次接触shell和插件开发，所以基本就是些小修小改，踩了很多坑，也没有进行完善的测试，所以如果使用中有什么问题请即时反馈。
- 由于原ServerChan插件停更了，考虑到企业微信机器人也是用MarkDown消息的，可以考虑后续在ServerChan插件上增加企业微信甚至钉钉机器人的支持（如果你是个程序猿，有了本插件，剩下的你直接自己实现得了）

## 插件说明

_在网上找了些图解实WebHook的，大体一个意思吧，并不是对此插件的详细解释，但是技术上是相类似的。_**简单的说**就是和ServerChan一样配置了类似的功能开关后，路由器就会在定时、设备上线、重拨等事件发生时，自动将你需要的内容组织成JSON格式的数据POST到你配置好的回调**URL们**中。

**例如：** 下面这个图，webhook图标下方可以理解为路由器的内部处理逻辑，下方出现事件触发后，通过本插件将数据消息推送到最上面的那些云端或本地服务中。这里的云端服务可以是你自己的服务器搭建的Web服务、可以是利用现在时下流行的无服务器计算搭建的云函数（例如腾讯云的SCF啦、百度云的函数计算啦、或者LeanCloud啦）
![](./res/webhook-1.png)

**再如：** 下面这个图，正好有个路由器（这么巧），然后那个IXON云理解为本插件就好了，嗯嗯。
![](./res/webhook-2.jpg)

> 也就是说，这个插件只是负责把通知消息发送到你自己的服务上，<font color=red>而服务的逻辑需要自己去实现哦！</font>所以对于小白来说可能不太适用（因为这个是需要开发后台服务的）那有个卵用呢？具体例子见下方说明。

## 使用方法

1. 软件中心安装
1. 配置回调URL（这里没做验证、任何校验和任何处理，你填写的URL将被原封不动的请求，也就是说`http://`或者`https://`这种不能省略，后面的路径和参数你也可以直接填写）
1. 配置好下方的消息内容开关
1. 通过点击`手动推送`按钮可以进行手动消息推送
1. 如果没啥bug的前提下，你配置的URL列表们就会依次收到路由器的消息回调了，具体的消息格式见下方
1. 服务器端收到的POST消息中`body`就是JSON序列化后的字符串，你需要进行反序列化哦（例如`JSON.parse(body)`)
1. 回调URL已支持环境变量功能，即系统会在请求URL前自动将URL中的所有`_PRM_EVENT`字符串替换为当前消息对应的`msgTYPE内容`（如你填写的URL为`https://www.baidu.com/_PRM_EVENT/search?type=_PRM_EVENT&info=aabbcc`则当系统中触发了`ifUP`事件时，回调的URL会变为`https://www.baidu.com/ifUP/search?type=ifUP&info=aabbcc`）
1. 目前触发类事件（网络重拨或客户端上线）已适配IFTTT官方的WebHook接口

## 应用举例

#### 通过IFTTT实现丰富功能
由于触发类事件以支持IFTTT的WEBHOOK功能，所以只需按照上述内容配置好你的IFTTT回调地址，即可在事件发生时触发IFTTT中的逻辑：比如给你手机打电话、发短信、推送消息、发邮件等等。

#### 自定义DDNS
由于插件可以实现定时或在重拨时推送你的公网IPv4和IPv6地址到你的URL中，所以你可以在自己的后台服务上对接其他的DNS厂商API从而实现更新域名的解析记录，达到DDNS的效果。虽然软件中心中提供了市面上常见的DNS（阿里的、疼讯云的等等），但是如果你还是用的其他的厂商，那么通过此插件你就可以轻松实现啦！（后台服务需要你自己开发哦）

#### 钉钉、企业微信机器人通知
有了此插件，你就可以实现钉钉、企业微信机器人的通知推送啦（这部分逻辑当然要自己实现，自己搭建后台服务），这样你就可以在有设备上线时（比如你老板的设备上线了，但人可能还没来哦），收到通知推送啦！

#### 网络重拨后更新防火墙规则
有了此插件，当你的路由器重新拨号后（如果你用的也是PPPoE拨号完了会随时变动外网IP那种），此插件会回调你的地址，这样你就可以更新云端的防火墙策略、安全组策略，实现只允许你当前IP进行SSH登录、MySQL登录等限制，提升云服务的安全性

#### 手机连上路由器智能家居实现回家场景联动
目前貌似只有设备上线的通知推送（下线的没有噻？），所以可以实现你即将到家的时候，手机已经连上你家的WIFI啦，这样插件可以回调你的局域网或云端的HA网关或者IFTTT这种，实现一系列的场景联动

#### 路由器温度高自动打开风扇降温
通过设置定时推送（有路由器的设备温度信息），当路由器温度高时，你的后台服务可以直接控制风扇进行路由器降温（当然这个后台服务你需要自己去实现）

## Tips:
- 开发过程中发现，若软件中心首页显示`更新中...`，多半是因为dbus挂了，目前不知道除了重启路由器怎么能够单独重启dbus服务。
- `/routerhook/version`文件中若版本号后面有换行，则会导致插件安装后，接口`http://xxx/_api/routerhook_`返回的JSON格式异常，导致软件中心界面`更新中...`
- 原ServerChan插件使用VSCode编辑`install.sh`和`uninstall.sh`的时候保存后会导致无法执行，提示`no such file or directory`，用记事本重新保存一下即可（可能是编码问题但我也没搞清楚，如果你遇到类似问题希望对你有帮助）

#### Windows下的打包命令：

> 貌似build.sh是可以进行打包的，但是具体怎么用我也不知道（看代码应该是需要拷贝到路由器上运行然后就可以打包啦？还请大神指点）

**打包**：在routerhook根目录打开gitbash，输入`tar -czvf routerhook.tar.gz routerhook/`即可

**解压**：解压命令：`tar -xzvf routerhook.tar.gz -C /目标地址`

#### 软件中心相关：

- 重置软件中心命令：SSH登录路由器后`koolshare-reset`，此操作会清空所有插件
- 查看软件中心运行：`ps|grep httpdb|grep -v grep`，有就说明有进程运行哈
- 停止软件中心命令：`sh -x /koolshare/perp/perp.sh stop`
- 启用软件中心命令：`sh -x /koolshare/perp/perp.sh start`
- 重启路由Web页面服务: `service restart_httpd`

## POST数据格式：

### 手动、定时推送长消息格式（不适配IFTTT）
```json5
{
	"msgTYPE": "manuINFO", // 定时推送时候type的值为cronINFO
	"sysINFO": {
		"routerNAME": "配置界面的设备标识", 
		"routerTIME": "2020年03月19日 09点08分15秒", // 路由器当前的设备时间
		"routerFIRMWARE": "384.14_0", // 路由器当前的固件版本
		"routerMODE": "无线路由器", // 路由器当前的工作模式：无线路由器、无线桥接模式、无线访问点 (Access Point)、Media Bridge、本次未获取到
		"routerUPTIME": "0天6时7分33秒", // 路由器的启动时间（根据下面的routerUPSECONDS格式化而来）
		"routerUPSECONDS": 22053, // 路由器启动时间的秒数（已经启动了多少秒）
		"routerAVGLOAD": [2.5, 2.24, 2.18], // 路由器负载[1min, 5min, 15min]
		"routerMEM": {
			"unit": "MB", // 内存单位
			"all": 429.99, // 全部内存
			"free": 140.42 // 剩余内存
		},
		"routerSWAP": {
			"free": 0, // 剩余SWAP
			"total": 0 // 全部SWAP
		},
		"routerJFFS": {
			"used": "3.7M", // 已使用JFFS空间大小（单位有K/M/G）
			"total": "48M", // 全部JFFS空间大小
			"available": "44.3M", // 可用JFFS空间大小
			"use":"9%" // 使用率
		}
	},
	"tempINFO": {
		"unit": "°C", // 温度单位
		"CPU": 72.4, // CPU核心温度
		"5G1": 53, // 5G_1温度
        "5G2": 53, // 5G_2温度（部分机型没有）
		"24G": 45 // 2.4G温度
	},
	"netINFO": {
		"WAN": [
			{ // 数组顺序分别对应WAN0和WAN1
				"proto": "pppoe", // WAN0的协议
				"pubIPv4": "xxx", // WAN0的公网IPv4
				"pubIPv6": "xxx", // WAN0的公网IPv6
				"wanIPv4": "xxx", // WAN0的端口IP
				"wanDNS": ["xxx", "xxx"], // WAN0的DNS
				"wanRX": "5.3 GiB", // WAN0的RX
				"wanTX": "483.4 MiB" // WAN0的TX
			}
		],
		"DDNS": "", // DDNS地址（非第三方插件配置）
        "chinaSTATUS" :"国内链接 【xxx】 ✓ 200ms", // 科学上网开启后才会有
        "foreignSTATUS":"国外链接 【xxx】 ✓ 500ms", // 科学上网开启后才会有
		"routerLANIP": "192.168.0.1", // 路由器本地地址
		"wifiINFO": { // WIFI接入点SSID信息，如下为smartconnect模式，否则会有24G:ssid,5G1:ssid,5G2:ssid
			"SmartConnect": "SSID"
		},
		"guestINFO": { // 访客WIFI的信息，可能会有24G1,24G2,24G3,5G11,5G12,5G13,5G21,5G22,5G23
			"24G1": "SSID_访客",
			"end": null // "end":null是个结束符，没有实际意义，只是为了保证json格式正确而已
		}
	},
	"usbINFO": [ // USB设备数组，分别对应USB1和USB2，一般USB1为USB3.0接口
        {},
	    {
		    "name": "General UDisk", // 设备名称
		    "status": "mounted", // 挂载状态removed,mounted
		    "total": "0", // 总容量（0或数字带单位）
		    "used": "0", // 已用空间（0或数字带单位）
		    "free": "0", // 可用空间（0或者数字带单位）
			"use": "0" // 使用率(0或者数字%)
	    }
    ],
	"cliINFO":[ // 在线客户端列表
		{
			"ip":"",
			"name":"",
			"mac":"" // 开启mac显示时才有
        }
	],
	"dhcpINFO":[ // DHCP租期内列表
		{
			"ip":"",
			"name":"",
			"mac":"" // 开启mac显示时才有
        }
	]
}
```

### 网络重拨上线消息格式（适配IFTTT）
```json5
{
	"msgTYPE":"ifUP",
	"upTIME":"0天 8小时 45分钟 12秒",
	"rebootTIME":"2020年03月19日 11点45分54秒",
	"netSTATE":[ // wan0,wan1数组
		{
			"proto":"pppoe",
			"pubIPv4":"公网IPv4",
			"pubIPv6":"公网IPv6",
			"wanIPv4":"wan口IPv4",
			"wanDNS": ["DNS1","DNS2"],
			"wanRX":"9.6 GiB",
			"wanTX":"1.0 GiB"
		}
	],
	"value1":"upTIME对应内容", // 适配IFTTT的键值对
	"value2":"wan0的pubIPv4", // 适配IFTTT的键值对
	"value3":"wan1的pubIPv4" // 适配IFTTT的键值对
}
```

### 设备上线消息格式（适配IFTTT）
```json5
{
	"msgTYPE": "newDHCP", // 消息type为newDHCP
	"cliNAME": "MI5C-aaa", // 设备名称
	"cliIP": "192.168.0.1", // 设备IP
	"cliMAC": "xxx", // 设备mac地址
	"upTIME": "2020年03月19日 09点44分38秒", // 上线时间
	"expTIME": "2020年03月20日 09点44分38秒", // dhcp过期时间
	"value1":"cliNAME对应内容", // 适配IFTTT的键值对
	"value2":"cliIP对应内容", // 适配IFTTT的键值对
	"value3":"cliMAC对应内容", // 适配IFTTT的键值对
	"cliLISTS":[ // DHCP租期内用户列表（开启开关时候显示）
		{
			"ip":"",
			"name":"",
			"mac":"" // 开启mac显示时才有
        }
    ]
}
```