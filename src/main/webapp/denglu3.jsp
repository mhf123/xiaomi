<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<title></title>
		<link rel="stylesheet" type="text/css" href="css/denglu3.css" />
		<script src="js/jquery-3.3.1.js"></script>
		<script type="text/javascript">
            //创建手机号验证的正则表达式
            var b = /^[1][3,4,5,7,8][0-9]{9}$/;
            //验证手机号
            var f1 = 0,f4 = 0;
            //输入框数据（手机号、验证码）
            var val1, val4;
            //验证码
            var code = "";

            //判断手机号码是否有效
            function on1() {
                val1 = $("#in2").val();
                if (val1 == ""){
                    $("#span1").show();
                    $("#span1").html("请输入手机号码！");
                    f1 = 0;
                } else if (!b.test(val1)) {
                    $("#span1").show();
                    $("#span1").html("请输入正确的手机号码！");
                    f1 = 0;
                } else {
                    $.ajax({
                        type: "post",
                        url: "/user/loginCheckPhone/" + val1,
                        //通过后台返回结果，提示用户结果
                        success: function (data) {
                            if (data.status == 1) {
                                $("#span1").html(data.msg + "！");
                                f1 = 0;
                            } else if (data.status == 0) {
                                $("#span1").hide();
                                f1 = 1;
                            } else {
                                $("#span1").html("未知错误！");
                                f1 = 0;
							}
                        },
                        dataType: "json"
                    })
                }
            }

            /**
             * 发送验证码
             */
            function yzm() {
                //验证手机号
                on1();
                if (f1 == 1) {
                    code = "";
                    var random = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);// 随机数
                    for (var i = 0; i < 6; i++) {// 循环操作
                        var index = Math.floor(Math.random() * 10);// 取得随机数的索引（0-9）
                        code += random[index];// 根据索引取得随机数加到code上
                    }
                    $.ajax({
                        type: "post",
                        url: "/user/verificationCode/" + val1 + "/" + code,
                        //通过后台返回结果，提示用户结果
                        success: function (data) {
                            if ($.parseJSON(data.data).respCode == "00000") {
                                var count = 60;
                                $("#but1").html("重新获取" + count);
                                $("#but1").attr('disabled', true);
                                $("#but1").css("color", "gray");
                                $("#but1").css("cursor", "auto");
                                var timer = setInterval(function () {
                                    count--;
                                    $("#but1").html("重新获取" + count);
                                    if (count == 0) {
                                        clearInterval(timer);
                                        $("#but1").attr("disabled", false);//启用按钮
                                        $("#but1").html("重新获取");
                                        $("#but1").css("color", "#FF6700");
                                        $("#but1").css("cursor", "pointer");
                                        setTimeout(function () {
                                            code = "";//10分钟后清除验证码。如果不清除，过时间后，输入收到的验证码依然有效
                                        },1000*60*10)
                                    }
                                }, 1000);
                            } else {
                                alert("验证码发送失败，错误代码：" + $.parseJSON(data.data).respCode);
                                return;
                            }
                        },
                        dataType: "json"
                    })

                }
            }

            //判断验证码是否正确
            function on4() {
                val4 = $("#in3").val();
                if (val4.length == 0) {
                    alert("请输入6位验证码！");
                    f4 = 0;
                } else if (val4 != code) {
                    alert("验证码错误！");
                    f4 = 0;
                } else {
                    f4 = 1;
                }
            }

            //登录
            function denglu() {
                on1();
                if (f1 == 1){
                    on4();
                }
                if (f1 == 1 && f4 == 1) {
					//将输入数据传到后台
                    $.ajax({
                        type: "post",
                        url: "/user/loginByPhone/" + val1,
                        dataType: "json",
                        success: function (data) {
                            if (data.status == 1) {
                                alert(data.msg + "！");
                            } else if (data.status == 0) {
                                location.href = "zhuye.jsp";
                            } else {
                                alert("登录失败！"+data.msg);
                            }
                            // if(s == "false")
                            // 	$("#dd").html("用户名或密码错误！")
                            // else
                            // 	window.location.href = "IndexServlet";
                        }

                    })

                }
            }
		</script>
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
					<a id="a2" href="">扫码登录</a>
				</div>
				<div class="d2-1-2">
					<div id="fo1">
						<div id="div1">
							<span id="span1"></span>
						</div>
						<div class="d2-1-2-1">
							<span id="sp4">+86</span>
							<input id="in2" class="in2" type="text" onblur="on1()" placeholder="手机号码" required="required">
						</div>
						<br/><br/><br/>
						<input id="in3" class="in3" type="text" placeholder="短信验证码" required="required">
						<button id="but1" type="button" onclick="yzm()">获取验证码</button>
			    		<br/><br/>
			    		<button class="b1" type="button" onclick="denglu()">立即登录</button>
			    		<br/>
			    		<a id="a3" href="denglu1.jsp ">用户名密码登录</a>
			    	</div>
			    </div>
			    <div class="d2-1-3 ">
			    	<br/><br/>
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