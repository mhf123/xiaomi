<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" href="css/bootstrap.css"/>
    <script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="css/zhuce.css"/>
    <title></title>

    <script type="text/javascript">
        //创建手机号验证的正则表达式
        var b = /^[1][3,4,5,7,8][0-9]{9}$/;
        //三个验证变量，分别验证手机号、密码、用户名、验证码
        var f1 = 0, f2 = 0, f3 = 0, f4 = 0;
        //四个输入框数据（手机号、密码、用户名、验证码）
        var val1, val2, val3, val4;
        //验证码
        var code = "";

        //判断手机号码是否有效
        function on1() {
            val1 = $("#username").val();
            if (val1 == ""){
                $("#span1").show();
                $("#span1").html("请输入手机号码！");
                f1 = 0;
            }else if (!b.test(val1)) {
                $("#span1").show();
                $("#span1").html("请输入正确的手机号码！");
                f1 = 0;
            } else {
                $.ajax({
                    type: "post",
                    url: "/user/checkValid/" + val1 + "/phone",
                    //通过后台返回结果，提示用户结果
                    success: function (data) {
                        if (data.status == 1) {
                            $("#span1").html(data.msg + "！");
                            f1 = 0;
                        } else if (data.status == 0) {
                            $("#span1").hide();
                            f1 = 1;
                        }
                    }
                })
            }
        }

        //判断密码格式是否正确
        function on2() {
            val2 = $("#password").val();
            if (val2.length == 0) {
                $("#span2").show();
                $("#span2").html("请输入密码！");
                f2 = 0;
            } else if (val2.length < 6 || val2.length > 12) {
                $("#span2").show();
                $("#span2").html("请输入6-12位长度的密码！");
                f2 = 0;
            } else {
                $("#span2").hide();
                f2 = 1;
            }
        }

        //判断输入用户名是否正确
        function on3() {
            val3 = $("#name").val();
            if (val3 == "") {
                $("#span3").show();
                $("#span3").html("请输入用户名！");
                f3 = 0;
            } else if (val3.length < 4 || val3.length > 12) {
                $("#span3").show();
                $("#span3").html("请输入4-12个字符的用户名！");
                f3 = 0;
            } else {
                $.ajax({
                    type: "post",
                    url: "/user/checkValid/" + val3 + "/username",
                    //通过后台返回结果，提示用户结果
                    success: function (data) {
                        if (data.status == 1) {
                            $("#span3").html(data.msg + "！");
                            f3 = 0;
                        }
                        else if (data.status == 0) {
                            $("#span3").hide();
                            f3 = 1;
                        }
                    }
                })
            }
        }

        //判断验证码是否正确
        function on4() {
            val4 = $("#yzm").val();
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
                            var timer = setInterval(function () {
                                count--;
                                $("#but1").html("重新获取" + count);
                                if (count == 0) {
                                    clearInterval(timer);
                                    $("#but1").attr("disabled", false);//启用按钮
                                    $("#but1").html("重新获取");
                                    $("#but1").css("color", "#FF6700");
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

        function zhuce() {
            on1();
            on2();
            on3();
            if (f1 == 1 && f2 == 1 && f3 == 1) {
                on4();
            }
            if (f1 == 1 && f2 == 1 && f3 == 1 && f4 == 1) {
                //判断是否选中同意协议框
                if (!$("#xieyi").is(':checked')) {
                    alert("请阅读并同意\"小米用户协议和隐私政策\"")
                } else {
                    //将输入数据传到后台
                    $.ajax({
                        type: "post",
                        url: "/user/register",
                        data: {
                            "phone": val1,
                            "password": val2,
                            "username": val3,
                            "role": 1
                        },
                        //通过后台返回结果，提示用户结果
                        success: function (data) {
                            if (data.status == 0) {
                                var t = confirm("注册成功，是否前往登录？")
                                if (t == true) {
                                    window.location.href = "denglu1.jsp";
                                }
                            } else {
                                alert("注册失败，"+data.msg);
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
    <img id="img1" src="img/zhuce1.png"/> <br/> <br/> <br/> <span
        class="sp1">注册小米账号</span>
    <div class="d1-1">
        <span>国家/地区</span> <br/> <select name="" class="form-control">
        <option value="">中国</option>
        <option value="">中国台湾</option>
        <option value="">中国香港</option>
    </select>
        <span class="sp2">成功注册帐号后，国家/地区将不能被修改</span> <br/>
        <span class="sp3">手机号码</span>
        <span class="span1" id="span1"></span>
        <div class="form-group">
            <input type="text" id="username" onblur="on1()" class="form-control" placeholder="请输入手机号码">
            <button id="but1" type="button" onclick="yzm()">获取验证码</button>
            <input id="yzm" type="text" class="in1" placeholder="请输入验证码">
            <span>用户名</span>
            <span class="span3" id="span3"></span>
            <input type="text" id="name" class="form-control" onblur="on3()" placeholder="请输入用户名">
            <span>密码</span>
            <span class="span2" id="span2"></span>
            <input type="password" id="password" class="form-control" onblur="on2()" placeholder="请输入密码">

            <button class="b1" onclick="zhuce()">立即注册</button>
        </div>
    </div>
    <br/> <br/>
    <span class="sp4"><input type="checkbox" id="xieyi">
        <label for="xieyi">注册帐号即表示您同意并愿意遵守小米用户协议和隐私政策</label>
    </span>

</div>
<div align="center">
    <br/> <a class="a6" href="">简体</a> <span class="sp2">|</span> <a
        class="a6" href="">繁体</a> <span class="sp2">|</span> <a class="a6"
                                                                href="">English</a> <span class="sp2">|</span> <a
        class="a6" href="">常见问题</a>
    <span class="sp2">|</span> <a class="a6" href="">隐私政策</a> <br/> <br/>
    <img style="text-align: center;" src="img/denglu5.png">
</div>
</body>
</html>
