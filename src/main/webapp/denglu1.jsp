<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8" />
<title></title>
<link rel="stylesheet" type="text/css" href="css/denglu1.css" />
<script src="js/jquery-3.3.1.js"></script>
<script type="text/javascript">
	//发送输入的用户名密码到后台进行验证
	function denglu(){
		var val1 = $("#text1").val();
		var val2 = $("#pass1").val();
		$.ajax({
			type : "post",
			url : "/xiaomi/login",
			data : {
				"username" : val1,
				"password" : val2
			},
			success : function(s) {
				if(s == "false")
					$("#dd").html("用户名或密码错误！")
				else
					window.location.href = "IndexServlet";
			}
			
		})
	}
	//进行用户名格式验证
	function onb() {
		var val1 = $("#text1").val();
		var b = /^[1][3,4,5,7,8][0-9]{9}$/;
		if (!b.test(val1)) {
			$("#dd").html("用户名格式有误！")
			//错误提示五秒后消失
			setTimeout(function() {
				document.getElementById("dd").innerHTML = ""
			}, 5000);
		}
	}
</script>
</head>

<body>
	<div class="d1">
		<a href=""><img id="img1" src="img/denglu2.png" /></a> <a href="">
			<img id="img3" src="img/denglu6.png" />
		</a>
	</div>
	<div class="d2">
		<div class="d2-1">
			<div class="d2-1-1">
				<a id="a1" href="">账号登录</a> <span id="sp1">|</span> <a id="a2"
					href="denglu2.html">扫码登录</a>
			</div>
			<div class="d2-1-2">
				<div id="dd"></div>
				<div id="fo1">
					<input class="in1" id="text1" name="username" type="text"
						onblur="onb()" placeholder="邮箱/手机号码/小米ID" required
						oninvalid="setCustomValidity('请输入用户名');"
						oninput="setCustomValidity('');"> <br /> <br /> <input
						class="in1" id="pass1" name="password" type="password"
						placeholder="密码" required oninvalid="setCustomValidity('请输入密码');"
						oninput="setCustomValidity('');"> <br /> <br />
					<button id="bb1" class="b1" onclick="denglu()">登录</button>

					<br /> <a id="a3" href="denglu3.jsp">手机短信登录/注册</a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="a6" href="zhuce.jsp">立即注册</a> <span class="sp2">|</span>
					<a class="a6" href="">忘记密码？</a>
				</div>
			</div>
			<div class="d2-1-3">
				<br /> <br /> <br /> <span id="sp3">其他方式登录</span>
				<hr />
				<a href=""><img id="img2" src="img/denglu3.png"></a>
			</div>
		</div>
	</div>
	<div align="center">
		<br /> <a class="a6" href="">简体</a> <span class="sp2">|</span> <a
			class="a6" href="">繁体</a> <span class="sp2">|</span> <a class="a6"
			href="">English</a> <span class="sp2">|</span> <a class="a6" href="">常见问题</a>
		<span class="sp2">|</span> <a class="a6" href="">隐私政策</a> <br /> <br />
		<img style="text-align: center;" src="img/denglu5.png">
	</div>
</body>

</html>