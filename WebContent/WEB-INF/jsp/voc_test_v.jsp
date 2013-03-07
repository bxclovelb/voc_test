<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>冰果英语—词汇量测试</title>
<script
	src="/voc_test/res/js/jquery-1.8.2.min.js" type="text/javascript"></script>
<script
	src="/voc_test/res/js/jquery-ui-1.9.2.custom.min.js"
	type="text/javascript"></script>

<link
	href="/voc_test/res/css/jquery-ui-1.9.2.custom.min.css"
	rel="stylesheet">
<link
	href="/voc_test/res/css/bootstrap.min.css" rel="stylesheet">

<style type="text/css">
	
	.body_head div{
		background:#30adb5;
	}
	
	.body_body div{
		background:#994cdc;
		margin-top:20px;
	}
	
	.body_footer div{
		background:#3b7aed;
		margin-top:20px;
	}
</style>

<script type="text/javascript">

	var userId = "";
	var level = 25;
	var no = 1;
	var count = 20;
	var times = 0;
	var answer = "";
	var right = 0;
	var wrong = 0;
	var cardsLeft = 0;
	var cardsRight = 0;
	var ifRight = false;
	var clickIfChecked = "unchecked";
	var numLevelYes = 0;
	var numLevel = 0;
	var SMOOTH = 50;
	var TOTAL_LEVEL = 50;
	var ids = new Array();
	 

	$(function(){
		userId = $("#hidden_user_id").val();
		updateStatistic();
		getQuestion();
	});

	//检测答案
	function checkAnswer(){
		var ans = $("#form_radios :checked");
		if(ans.val() == null || ans.val == ""){
			$("#div_choose_item").dialog({
				autoOpen:false,
				draggable:true,
				modal:true,
				resizable:false,
				width:500,
				height:250,
				title:"<div><span class='badge badge-important' style='font-size:15pt'>冰果助手提醒您</span></div>"
			});
			$("#div_choose_item").dialog("open");
			return false;
		}
		
		if(ans.val() == answer){
			ifRight = true;
			right++;
			if(times>0){
				times++;
			}else{
				times=1;
			}
		}else{
			wrong++;
			if(times<0){
				times--;
			}else{
				times=-1;
			}
		}
		
		return true;
	}

	//增加卡片
	function showCard(){
		if(no == 2){
			$("#div_cards_left").html("");
			$("#div_cards_right").html("");
		}

		if(times > 0){
			var divCard = $("<div class='btn-success' style='overflow:auto;margin-top:3%;width:100%;height:80px;'></div>");
			if($.browser.msie&&parseInt($.browser.version,10)===6){
				divCard.append("<span class='badge badge-success' style='color:black'>R</span><br>"
					+"<span style='padding-left:0%;'>"+$("#span_head_word").html()+"</span>"
					+"<span style='padding-left:10%'>level:"+level+"</span>"+"<br>");
			}else{
				divCard.append("<span class='badge badge-success'><i class='icon-ok icon-white'></i></span><br>"
					+"<span style='padding-left:0%;'>"+$("#span_head_word").html()+"</span>"
					+"<span style='padding-left:10%'>level:"+level+"</span>"+"<br>");
			}
			divCard.append("<span>正确释义："+answer+"</span>");
		}else{
			var divCard = $("<div class='btn-danger' style='overflow:auto;margin-top:3%;width:100%;height:80px;'></div>");
			if($.browser.msie&&parseInt($.browser.version,10)===6){
				divCard.append("<span class='badge badge-important' style='color:black'>F</span><br>"
						+"<span style='padding-left:0%'>"+$("#span_head_word").html()+"</span>"
						+"<span style='padding-left:10%'>level:"+level+"</span>"+"<br>");
			}else{
				divCard.append("<span class='badge badge-important'><i class='icon-remove'></i></span><br>"
					+"<span style='padding-left:0%'>"+$("#span_head_word").html()+"</span>"
					+"<span style='padding-left:10%'>level:"+level+"</span>"+"<br>");
			}
			
				divCard.append();
			divCard.append("<span>正确释义："+answer+"</span>"+"<br>");
			divCard.append("<span'>你的答案："+$("#form_radios :checked").val()+"</span>");
		}

		var leftNum = cardsLeft;
		var rightNum = cardsRight;
		if(leftNum != 7){
			$("#div_cards_left").append(divCard);
			divCard.effect("slide",{},500);
			cardsLeft = leftNum + 1;
		}else if(rightNum != 7){
			$("#div_cards_right").append(divCard);
			divCard.effect("slide",{},500);
			cardsRight = rightNum + 1;
		}else{
			$("#div_cards_left div").first().remove();
			$("#div_cards_left").append($("#div_cards_right div").first());
			$("#div_cards_right").append(divCard);
			divCard.effect("slide",{},500);
		}
	}

	//滑出效果
	function slide(id){
		$("#"+id).effect("slide",{},500);
	}

	//下一个问题
	function nextQuestion(){
		var success = checkAnswer();
		if(success){
			slide("div_body_body");
			showCard();
			updateStatistic();
			getQuestion();
		}
	}

	//显示结果
	function showResult(){
		$("#div_question_head").html("");
		$("#div_question_body").html("");
		$("#div_question_footer").html("");

		$("#div_question_head").append("<p style='font-size:25pt;padding:5%;border-bottom:1px solid gray'>完成</p>");
		var divContent = $("<div style='font-size:15pt;margin:15px;'></div>");
		divContent.append("<span style='font-size:15pt'>恭喜您，您已经完成了"+count+"个单词测试。</span><br/><br/>");
		divContent.append("<span style='font-size:15pt'>您的词汇量为："+(level*200)+"-"+(level*200+200)+"</span><br/><br/><br/><br/>");
		divContent.append("<span style='font-size:15pt'>注：注册成为冰果正式用户，可以提交测试结果，冰果英语会根据您的测试结果，自动为您选择最优的学习方案，并根据您在冰果的学习状况动态安排您的学习内容。</span>");
		$("#div_question_body").append(divContent);
		var divNext = $("<div align='right' style='padding:10px;margin-top:15px;border-top:1px solid gray'></div>");
		divNext.append("<button class='btn btn-info' onclick='nextTest();'>继续测试</button>");
		$("#div_question_footer").append(divNext);
	}

	//保存用户单词量
	function saveVocabulary(){
		$.ajax({
			url:"/voc_test/saveVocabulary?userId="+userId+"&vocabulary="+(level*200),
			type:"get"
		});
	}

	//显示是否继续做题提示框
	function showNextDialog(){
		var success = checkAnswer();
		if(success){
			showCard();
			showResult();
			updateStatistic();
			updateVocCount();
			saveVocabulary();

			$("#span_voc_count").html("");
			$("#span_voc_level").html("");

			$("#span_voc_count").append(count);
			$("#span_voc_level").append((level*200)+"-"+(level*200+200));

			$("#div_next_test").dialog({
				autoOpen:false,
				draggable:true,
				modal:true,
				resizable:false,
				width:500,
				height:250,
				title:"<div style='font-size:16px;'><span class='badge badge-success' style='font-size:15pt'>冰果助手提醒您</span></div>"
			});
			$("#div_next_test").dialog("open");
		}
	}

	//继续测验
	function nextTest(){
		if($( "#div_next_test" ).dialog( "isOpen" )){
			$("#div_next_test").dialog("close");
		}
		slide("div_body_body");
		count += 20; 
		updateStatistic();
		getQuestion();
	}

	//更新统计
	function updateStatistic(){
		$("#div_body_head").html("");

		var theNo = no;
		if(no > count){
			theNo = count;
		}
		
		$("#div_body_head").append("<strong>题目:"+theNo+"/"+count+"</strong>"
			+"<strong style='padding-left:10%'>正确:<span class='btn-success'>"+right+"</span></strong>"
			+"<strong style='padding-left:10%'>错误:<span class='btn-danger'>"+wrong+"</span></strong>");
	}

	//更新单词量
	function updateVocCount(){
		if(ifRight){
			$("#span_cur_voc_level").html("");
	
			var vocCount = level * 200;
			$("#span_cur_voc_level").append(vocCount+"-"+(vocCount+200));
		}
		$("#p_estimate").html("");
		if(no <= 10){
			$("#p_estimate").append("<strong>温馨提示：</strong>测试单词较少，词汇量判断可能不准确。"+"<br>");
		}
		if(times >= 3){
			$("#p_estimate").append("<strong>冰果助手：</strong>");
			$("#p_estimate").append("哇塞，好棒！连续对"+times+"道题！保持住！"+"<br>");
		}
		if(times <= -3){
			$("#p_estimate").append("<strong>冰果助手：</strong>");
			$("#p_estimate").append("oh，no！连续答错"+(-times)+"道题啦！仔细看题，你能行的！"+"<br>");
		}
		if(ifRight){
			$("#p_estimate").append("<strong>评价：</strong>");
			if(vocCount > 0 && vocCount <= 2800){
				$("#p_estimate").append("根据您的做题结果，您的词汇量属于一般水平。好好努力，积少成多！"+"<br>");
			}else if(vocCount > 2800  && vocCount <= 7000){
				$("#p_estimate").append("根据您的做题结果，您的词汇量属于良好水平。继续努力，还有很大的进步空间！"+"<br>");
			}else{
				$("#p_estimate").append("根据您的做题结果，您的词汇量属于优秀水平。继续保持~"+"<br>");
			}
		}
	}

	//获得一个问题
	function getQuestion(){
		$("#div_question_head").html("");
		$("#div_question_body").html("");
		$("#div_question_footer").html("");

		$("#div_question_body").html("<img src='/voc_test/res/img/2897814_144041193193_2.gif' style='width:460px;height:364px'/>");

		var next_level = level;
		if(no > 1){
			numLevel += level;
			if(times > 0){
				var guess = 1.012 - level*0.012;	
				numLevelYes += level * guess/(0.75*guess + 0.25);
			}
			var estimate = (numLevelYes+0.4*SMOOTH)/(numLevel+SMOOTH);
			next_level = Math.floor(estimate*TOTAL_LEVEL+0.5);
		}

		var ran = Math.random();
		$.getJSON("/voc_test/loadQuestion?nextLevel="+next_level+"&r="+ran,
			function(data){
			var exist = false;
			for(var i=0;i<ids.length;i++){
				if(ids[i] == data.question.id){
					exist = true;
					break;
				}
			}
			if(exist){
				if(no > 1){
					numLevel -= level;
					if(times > 0){
						var guess = 1.012 - level*0.012;	
						numLevelYes -= level * guess/(0.75*guess + 0.25);
					}
				}
				getQuestion();
				return;
			}
			
			$("#div_question_head").html("");
			$("#div_question_body").html("");
			$("#div_question_footer").html("");
			
			$("#div_question_head").append("<p style='font-size:25pt;padding:5%;border-bottom:1px solid gray'>"
				+no+". <span id='span_head_word'>"+data.question.word+"</span></p>");

			var formRadios = $("<form id='form_radios'></form>");
			var nos = ["0","1","2","3"];
			var length = nos.length;
 			for(var i=0;i<length;i++){
 				var index =  Math.floor(Math.random() * length);
 				
				var item = nos[index];
				nos[index] = nos[i];
				nos[i] = item;
			}
			for(var i=0;i<length;i++){
				var divRadio = $("<div id='div_radio_"+i+"' style='font-size:18pt;margin:15px;padding:10px'></div>");
				if(i%2 != 0){
					divRadio.css("background-color","#b680e5");
					divRadio.hover(
						function(){
							$(this).css("background-color","#d6b1f6");
						},
						function(){
							$(this).css("background-color","#b680e5");
						}
					);
				}else{
					divRadio.css("background-color","#ae5df4");
					divRadio.hover(
						function(){
							$(this).css("background-color","#d6b1f6");
						},
						function(){
							$(this).css("background-color","#ae5df4");
						}
						
					);
				}
				if(i == nos[0]){
					divRadio.append("<input type='radio' name='items' value='"+data.question.options[0]+"' style='width:30px'> "+data.question.options[0]+"</input>");
					answer = data.question.options[0];
				}else if(i == nos[1]){
					divRadio.append("<input type='radio' name='items' value='"+data.question.options[1]+"' style='width:30px'> "+data.question.options[1]+"</input>");
				}else if(i == nos[2]){
					divRadio.append("<input type='radio' name='items' value='"+data.question.options[2]+"' style='width:30px'> "+data.question.options[2]+"</input>");
				}else if(i == nos[3]){
					divRadio.append("<input type='radio' name='items' value='"+data.question.options[3]+"' style='width:30px'> "+data.question.options[3]+"</input>");
				}
				divRadio.bind("click",function(){
					$(this).children("input").attr("checked","true");
				}); 
				formRadios.append(divRadio);
			}
			$("#div_question_body").append(formRadios);

			var divNext = $("<div style='padding:10px;margin-top:15px;border-top:1px solid gray;height:30px'></div>");
			if(no % 20 != 0){
				var ifChecked = clickIfChecked;
				divNext.append("<button class='btn btn-info' onclick='nextQuestion();' style='float:right'>下一题</button>");
				if(ifChecked == "checked"){
					divNext.append("<input id='checkbox_click' type='checkbox' onclick='toggleClick();' checked='checked' style='width:30px'><span>单击进入下一题</span>");
					bindclick();
				}else{
					divNext.append("<input id='checkbox_click' type='checkbox' onclick='toggleClick();' style='width:30px'><span>单击进入下一题</span>");
				}
				
			}else{
				divNext.append("<button class='btn btn-info' onclick='showNextDialog();' style='float:right'>完成</button>");
			}
			$("#div_question_footer").append(divNext);

			level = next_level;
			ids.push(data.question.id);
			updateVocCount();
			no++;	
		});

	}

	function bindclick(){
		for(var i=0;i<4;i++){
			$("#div_radio_"+i).bind("click",function(){
				$(this).children("input").attr("checked","true");
				nextQuestion();
			});
		}
	}

	function unbindclick(){
		for(var i=0;i<4;i++){
			$("#div_radio_"+i).unbind("click");
			$("#div_radio_"+i).bind("click",function(){
				$(this).children("input").attr("checked","true");
			});
		}
	}

	function toggleClick(){
		var ifChecked = $("#checkbox_click").attr("checked");
		if(ifChecked == "checked"){
			bindclick();
			clickIfChecked = "checked";
		}else{
			unbindclick();
			clickIfChecked = "unchecked";
		}
	}

	//转向个人词汇信息
	function goToVocInfo(){
		window.location = "/voc_info/index.php/voc_info_c/index/"+userId;
	} 

	//转向词汇练习
	function goToVocExer(){
		//题目套数
		var num_exer = 1;
		
		$.getJSON("/voc_info/index.php/voc_info_c/get_random_exers/"+num_exer,function(data){
			window.location = "/voc_exe/index.php/voc_exe_c/index/"+userId+"/v-31-"+data[0];	
		});
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
</script>

<!--[if IE 6]>
	<link href="/voc_test/res/css/ie6.min.css" rel="stylesheet">
<![endif]-->
</head>
<body style="background:#320778;color:white;">
	<!-- navbar -->
	<div class="navbar navbar-fixed-top navbar-inverse">
		<div class="navbar-inner">
		<img src="/voc_info/res/images/bingo.png" style="float:left">
			<a class="brand" href="###" >冰果英语</a>
			<ul class="nav">
				<li><a href="###" onclick="goToVocInfo();">个人词汇信息</a></li>
				<li><a id="a_vocbook" href="###" onclick="goToVocbook();">词汇本</a></li>
				<li class="active"><a id="a_voc_test" href="###">词汇量测试</a></li>
				<li><a id="a_voc_exe" href="###" onclick="goToVocExer();">词汇练习</a></li>
			</ul>
		</div>
	</div>
	<!-- navbar end -->
	
	<div class="container" style="margin-top:3%">
		<div align="center" style="color:white;font-size:40pt;background-color: #c01179;padding:5%;height: auto;">
			冰果英语词汇量测试
		</div>
		<div class="row-fluid" style="margin-top:2%">
			<div class="span3">
				<div align="center" style="width:90%;background:#f6a828;font-size:15pt;padding:5%">已测单词</div>
				<div id="div_cards_left" style="height:606px;border:1px solid #f6a828">
					<div style="font-size:15pt;color:white;padding:10%;direction: inherit;">想知道自己的词汇量么?快来试试吧~</div>
				</div>
			</div>
    		<div class="span6" style="margin-left:20px">
    			<div class="body_head">
    				<div id="div_body_head" style="padding:3%;font-size:15pt;" align="center"></div>
    			</div>
    			
	    		<div class="body_body" style="height:400px">
		    		<div id="div_body_body">
		    			<div id="div_question_head"></div>
		    			<div id="div_question_body" style="height:250px"></div>
		    			<div id="div_question_footer"></div>
	    			</div>
    			</div>
    			
    			<div class="body_footer" style="margin-top:30px">
	    			<div id="div_body_footer" style="padding:3%;font-size:15pt">
						<p><strong> 您目前的词汇量是：</strong><span id="span_cur_voc_level">0</span></p>
						<p id="p_estimate"></p>	
	    			</div>
    			</div>
    		</div>
    		<div class="span3" style="margin-left:20px">
				<div align="center" style="width:90%;background:#f6a828;font-size:15pt;padding:5%">已测单词</div>
				<div id="div_cards_right" style="height:606px;border:1px solid #f6a828">
					<div style="font-size:15pt;color:white;padding:10%;direction: inherit;">想知道自己的词汇量么?快来试试吧~</div>
				</div>
			</div>
    	</div>
	</div>
	<div id="div_choose_item" style="display: none;">
		<br>
		<span>错误：请选择一个选项。</span>
	</div>
	<div id="div_next_test" style="display: none;">
		<br>
		<p>您已完成<span id="span_voc_count"></span>个单词，您的词汇量为：<span id="span_voc_level"></span></p><br>
		<p>冰果英语提示您，多做题可以更加精准地测出词汇量，是否继续测试？</p><br>
		<div align="center">
			<button class="btn btn-primary" onclick="nextTest();">继续测试</button>
			<button class="btn" onclick="$('#div_next_test').dialog('close');" style="margin-left:10%">结束测试</button>		
		</div>
	</div>
	
	<form>
		<input type="hidden" id="hidden_user_id" value="<s:property value="userId"></s:property>" />
	</form>
	
	<script>
		$(function(){if($.browser.msie&&parseInt($.browser.version,10)===6){$('.row div[class^="span"]:last-child').addClass("last-child");$(':button[class="btn"], :reset[class="btn"], :submit[class="btn"], input[type="button"]').addClass("button-reset");$(":checkbox").addClass("input-checkbox");$('[class^="icon-"], [class*=" icon-"]').addClass("icon-sprite");$(".pagination li:first-child a").addClass("pagination-first-child")}})
	</script>
</body>
</html>