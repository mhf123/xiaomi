<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<title></title>
		<link rel="stylesheet" type="text/css" href="css/denglu3.css" />
	</head>

	<body>
		<div class="d1">
			<a href=""><img id="img1" src="img/denglu2.png" /></a>
			<a href="">
				<img id="img3" src="img/denglu6.png" />
			</a>
		</div>
		<div class="d2">
			<div class="d2-1">
				<div class="d2-1-1">
					<a id="a1" href="">账号登录</a>
					<span id="sp1">|</span>
					<a id="a2" href="denglu2.html">扫码登录</a>
				</div>
				<div class="d2-1-2">
					<form id="fo1">
						<div class="d2-1-2-1">
							<span id="sp4">+86</span>
							<input class="in2" type="text" placeholder="手机号码" required="required">
						</div>
						<br/><br/><br/>
						<input class="in3" type="text" placeholder="短信验证码" required="required">
						<button id="but1" type="button" onclick="alert('验证码已发送到你的手机')" ">获取验证码</button> 
			    		<br/><br/>
			    		<button class="b1" type="submit" onclick="location.href='zhuye.html'">立即登录/注册</button> 
			    		<br/>
			    		<a id="a3" href="denglu1.html ">用户名密码登录</a>
			    	</form>
			    </div>
			    <div class="d2-1-3 ">
			    	<br/><br/><br/>
			    	<span id="sp3">其他方式登录</span>
			    	<hr/>
			    	<a href=" "><img id="img2" src="img/denglu3.png "></a>
			    </div>
		    </div>
		</div>
		<div align="center">
			<br/>
			<a class="a6" href=" ">简体</a>
			<span class="sp2 ">|</span>
			<a class="a6" href=" ">繁体</a>
			<span class="sp2 ">|</span>
			<a class="a6" href=" ">English</a>
			<span class="sp2 ">|</span>
			<a class="a6" href=" ">常见问题</a>
			<span class="sp2 ">|</span>
			<a class="a6" href=" ">隐私政策</a>
			<br/><br/>
			<img class="img3" src="img/denglu5.png ">
		</div>
	</body>
</html>