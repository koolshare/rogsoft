<script type="text/javascript" src="/js/jquery.js"></script>
<script language="javascript">
	function redirect(){
		var current_url = window.location.href;
		console.log(current_url);
		console.log(current_url.indexOf("ddns.to"));
		sub_domain = current_url.split("/")[2].split(".")[0];
		if(current_url.indexOf("ddnsto") != -1){
			location.href = "https://" + sub_domain + "-cmd.ddnsto.com/"
		}else{
			location.href = "http://" + location.hostname + ":4200/"
		}
	}
	function try_on(){
		var id = parseInt(Math.random() * 100000000);
		var postData1 = {"id": id, "method": "shellinabox_config.sh", "params":["1"], "fields": ""};
		$.ajax({
			type: "POST",
			url: "/_api/",
			async:true,
			cache:false,
			data: JSON.stringify(postData1),
			dataType: "json",
			success: function(response) {
				if(response.result == id){
					redirect();
				}else{
					alert("shellinabox启动错误，错误代码：" + response.result);
				}
			},
			error: function(){
				alert("shellinabox启动错误!")
			}
		});
	}
	try_on();
</script>
