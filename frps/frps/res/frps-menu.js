function openssHint(itemNum){
    statusmenu = "";
    width="350px";

    if(itemNum == 0){
        statusmenu ="如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
        _caption = "服务器说明";
    }
    else if(itemNum == 1){
        statusmenu ="此处填入你的frp服务器的控制台端口，对应服务器配置文件中的节[common]下的dashboard_port字段<br/>";
        _caption = "Dashboard port";
    }
    else if(itemNum == 2){
        statusmenu ="此处填入你的frp服务器的服务端口，对应服务器配置文件中的节[common]下的bind_port字段";
        _caption = "Bind port";
    }
    else if(itemNum == 3){
        statusmenu ="此处填入你的frp服务器的特权授权码。对应服务器配置文件中的节[common]下的privilege_token字段。<br/><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致frpc链接不上服务器。";
        _caption = "Privilege Token";
    }
    else if(itemNum == 4){
        statusmenu ="此处填入你的frp服务器HTTP穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_http_port字段";
        _caption = "vhost http port";
    }
    else if(itemNum == 5){
        statusmenu ="此处填入你的frp服务器HTTPS穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_https_port字段";
        _caption = "vhost https port";
    }
    else if(itemNum == 6){
        statusmenu ="此处是否开启frpc客户端日志。<br/><font color='#F46'>注意：</font>默认不开启，开启后日志路径为/tmp/frpc.log";
        _caption = "日志记录";
    }
    else if(itemNum == 7){
        statusmenu ="此处选择日志记录等级。<br/>可选内容：info、warn、error、debug。";
        _caption = "日志等级";
    }
    else if(itemNum == 8){
        statusmenu ="此处选择要保留的日志天数。";
        _caption = "日志记录天数";
    }
    else if(itemNum == 9){
        statusmenu ="最大连接池数量。<br/>默认情况下，当用户请求建立连接后，frps 才会请求 frpc 主动与后端服务建立一个连接。当为指定的代理启用连接池后，frp 会预先和后端服务建立起指定数量的连接，每次接收到用户请求后，会从连接池中取出一个连接和用户连接关联起来，避免了等待与后端服务建立连接以及 frpc 和 frps 之间传递控制信息的时间";
        _caption = "max pool count";
    }
    else if(itemNum == 10){
        statusmenu ="定时到Frp服务器上重新注册服务，以便Frp提供持续的服务。<br/><font color='#F46'>注意：</font>填写内容为0时关闭该功能！";
        _caption = "定时注册服务";
    }
    else if(itemNum == 11){
        statusmenu ="控制台登录用户名";
        _caption = "Dashboard User";
    }
    else if(itemNum == 12){
        statusmenu ="控制台登录密码";
        _caption = "Dashboard Pas";
    }
    else if(itemNum == 13){
        statusmenu ="从 v0.10.0 版本开始，客户端和服务器端之间的连接支持多路复用，不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 frp 可以承载更高的并发数。</br>该功能默认启用，如需关闭，可以在 frps.ini 和 frpc.ini 中配置，该配置项在服务端和客户端必须一致.";
        _caption = "TCP 多路复用";
    }
        //return overlib(statusmenu, OFFSETX, -160, LEFT, DELAY, 200);
        //return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, " ", FGCOLOR, "#4D595D", CAPCOLOR, "#000000", CLOSECOLOR, "#000000", MOUSEOFF, "1",TEXTCOLOR, "#FFF", CLOSETITLE, '');
        return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

    var tag_name= document.getElementsByTagName('a');
    for (var i=0;i<tag_name.length;i++)
        tag_name[i].onmouseout=nd;

    if(helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
        return overlib('<#defaultHint#>', HAUTO, VAUTO);
    else if(hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
        return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
    else{
        if(hint_show_id > helpcontent[hint_array_id].length)
            return overlib('<#defaultHint#>', HAUTO, VAUTO);
        else
            return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
    }
}
