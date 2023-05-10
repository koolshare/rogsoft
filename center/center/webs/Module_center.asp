<script type="text/javascript" src="/js/jquery.js"></script>
<script language="javascript">
	function sleep (time) {
		return new Promise((resolve) => setTimeout(resolve, time));
	}
	function try_on(){
		var id = parseInt(Math.random() * 100000000);
		var postData1 = {"id": id, "method": "center_config.sh", "params":["1"], "fields": ""};
		$.ajax({
			type: "POST",
			url: "/_api/",
			async:true,
			cache:false,
			data: JSON.stringify(postData1),
			dataType: "json",
			success: function(response) {
				if(response.result == id){
					sleep(100).then(() => {
						location.href = "Module_Softcenter.asp"
					});
				}else{
					sleep(100).then(() => {
						location.href = "Module_Softcenter.asp"
					});
				}
			},
			error: function(){
				alert("错误，切换失败!")
				location.href = "Module_Softcenter.asp"
			}
		});
	}
	try_on();
</script>
