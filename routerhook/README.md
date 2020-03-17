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