<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
<script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
<script src="js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="css/zhuce.css" />
<title></title>

<script type="text/javascript">
	//创建手机号验证的正则表达式
	var b = /^[1][3,4,5,7,8][0-9]{9}$/;
	//三个验证变量，分别验证手机号、密码、昵称
	var f1, f2, f3;
	//判断手机号码格式是否正确
	function on1() {
		val1 = $("#username").val();
		if (!b.test(val1)) {
			$("#span1").show();
			$("#span1").html("请输入正确的手机号码！")
			setTimeout(function() {
				$("#span1").hide();
			}, 10000);
			f1 = 0;
		} else
			f1 = 1;
	}
	//判断密码格式是否正确
	function on2() {
		val2 = $("#password").val();
		if (val2.length == 0) {
			$("#span2").show();
			$("#span2").html("请输入密码！")
			setTimeout(function() {
				$("#span2").hide();
			}, 10000);
			f2 = 0;
		} else if (val2.length < 6) {
			$("#span2").show();
			$("#span2").html("密码长度过短！")
			setTimeout(function() {
				$("#span2").hide();
			}, 10000);
			f2 = 0;
		} else {
			f2 = 1;
		}
	}
	//判断是否输入用户名
	function on3() {
		val3 = $("#name").val();
		if (val3 == "") {
			$("#span3").show();
			$("#span3").html("请输入昵称！")
			setTimeout(function() {
				$("#span3").hide();
			}, 10000);
			f3 = 0;
		} else
			f3 = 1;
	}
	
	function zhuce() {
		//执行前三个判断函数
		on1();
		on2();
		on3();
		if (f1 == 1 && f2 == 1 && f3 == 1) {
			//判断是否选中同意协议框
			if (!$("#xieyi").is(':checked')) {
				alert("请阅读并同意\"小米用户协议和隐私政策\"")
			} else {
				//将输入数据传到后台
				$.ajax({
					type : "post",
					url : "/xiaomi/RegisterServlet",
					data : {
						"username" : val1,
						"password" : val2,
						"name" : val3
					},
					//通过后台返回结果，提示用户结果
					success : function(s) {
						if (s == "false") {
							var t = confirm("此用户已注册，是否前往登录？")
							if (t == true) {
								window.location.href = "denglu1.jsp";
							}
						} else {
							var t = confirm("注册成功，是否前往登录？")
							if (t == true) {
								window.location.href = "denglu1.jsp";
							}
						}
					}

				})
			}
		}

	}
</script>
</head>

<body>
	<div class="d1">
		<img id="img1" src="img/zhuce1.png" /> <br /> <br /> <br /> <span
			class="sp1">注册小米账号</span>
		<div class="d1-1">
			<span>国家/地区</span> <br /> <select name="" class="form-control">
				<option value="">中国</option>
				<option value="">中国台湾</option>
				<option value="">中国香港</option>
				<option value="">United States</option>
			</select> <span class="sp2">成功注册帐号后，国家/地区将不能被修改</span> <br /> <span
				class="sp3">手机号码</span> <span class="span1" id="span1"></span>
			<div class="form-group">
				<input type="text" id="username" onblur="on1()" class="form-control"
					placeholder="请输入手机号码">
				<button id="but1" type="button" onclick="alert('验证码已发送到你的手机')">获取验证码</button>
				<input type="text" class="in1" placeholder="请输入验证码"> <span>密码</span><span
					class="span2" id="span2"></span> <input type="password"
					id="password" class="form-control" onblur="on2()"
					placeholder="请输入密码"> <span>昵称</span><span class="span3"
					id="span3"></span> <input type="text" id="name"
					class="form-control" onblur="on3()" placeholder="请输入昵称">
				<button class="b1" onclick="zhuce()">立即注册</button>
			</div>

		</div>
		<br /> <br /> <span class="sp4"><input type="checkbox"
			id="xieyi"><label for="xieyi">注册帐号即表示您同意并愿意遵守小米用户协议和隐私政策</label></span>

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
