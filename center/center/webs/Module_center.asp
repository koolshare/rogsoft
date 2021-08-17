<script type="text/javascript" src="/js/jquery.js"></script>
<script language="javascript">
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
					//alert("切换成功！");
					location.href = "Module_Softcenter.asp"
				}else{
					alert(response.result);
					location.href = "Module_Softcenter.asp"
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
