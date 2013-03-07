	//转向个人词汇信息
	function goToVocInfo(){
		window.location = "/voc_info/index.php/voc_info_c/index/"+userId;
	} 

	//转向词汇量测试
	function goToVocTest(){
		window.location = "/voc_test/index.php/voc_test_c/index/"+userId;
	}
	
	//转向词汇本
	function goToVocbook(){
		//获得用户上一次所选级别
		$.getJSON("/voc_info/index.php/voc_info_c/get_user_band/"+userId+"/"+Math.random(),
			function(data){
				//转向词汇本
				window.location = "/vocabulary/index.php/vocabulary_c/show_normal/"+userId+"/"+data+"/0";
			}
		);
	}