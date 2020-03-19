# RouterHook通知回调插件

> 感谢ServerChan插件作者，本插件基本都是在ServerChan插件基础上进行修改的

使用VSCode编辑`install.sh`和`uninstall.sh`的时候保存后会导致无法执行，提示`no such file or directory`，用记事本重新保存一下即可（可能是编码问题但我也没搞清楚）

## Windows下的打包命令：
在routerhook根目录打开gitbash，输入`tar -czvf routerhook.tar.gz routerhook/`即可
解压命令：`tar -xzvf routerhook.tar.gz -C /目标地址`

## 软件中心：
重置软件中心命令：SSH登录后`koolshare-reset`，此操作会清空所有插件
查看软件中心运行：`ps|grep httpdb|grep -v grep`
停止软件中心命令：`sh /koolshare/perp/perp.sh stop`
启用软件中心命令：`sh /koolshare/perp/perp.sh start`

## 数据格式：

### 手动、定时推送长消息格式
```json
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
			"used": 3.7, // 已使用JFFS空间大小
			"total": 48 // 全部JFFS空间大小
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
		"WAN": [{ // 数组顺序分别对应WAN0和WAN1
			"proto": "pppoe", // WAN0的协议
			"pubIPv4": "xxx", // WAN0的公网IPv4
			"pubIPv6": "xxx", // WAN0的公网IPv6
			"wanIPv4": "xxx", // WAN0的端口IP
			"wanDNS": ["xxx", "xxx"], // WAN0的DNS
			"wanRX": "5.3 GiB", // WAN0的RX
			"wanTX": "483.4 MiB" // WAN0的TX
		}],
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
		    "total": 0, // 总容量
		    "used": 0, // 已用空间
		    "free": 0 // 可用空间
	    }
    ]
}
```

### 网络重拨上线消息格式
```json
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
]}

```

### 设备上线消息格式
```json
{
	"msgTYPE": "newDHCP", // 消息type为newDHCP
	"cliNAME": "MI5C-aaa", // 设备名称
	"cliIP": "192.168.0.1", // 设备IP
	"cliMAC": "xxx", // 设备mac地址
	"upTIME": "2020年03月19日 09点44分38秒", // 上线时间
	"expTIME": "2020年03月20日 09点44分38秒", // dhcp过期时间
    "cliLISTS":[ // DHCP租期内用户列表（开启开关时候显示）
        {
            "ip":"",
            "name":"",
            "mac":"" // 开启mac显示时才有
        }
    ]
}
```