<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" href="css/bottom.css"/>
    <link rel="stylesheet" type="text/css" href="css/fukuan.css"/>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css"/>
    <script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
    <script src="js/zhuye.js" type="text/javascript" charset="utf-8"></script>
    <style type="text/css">
    </style>
    <script type="text/javascript">
        //创建订单时间
        var time;
        //计时器
        var t;
        //订单号
        var orderNo;
        /**
         * 网页加载完成后
         */
        $(document).ready(function () {
            //获取订单号
            orderNo = getUrlParam("orderNo");
            //加载订单数据
            $.ajax({
                type: "post",
                url: "/order/detail/" + orderNo,
                success: function (data) {
                    if (data.status == 0) {
                        //创建订单时间
                        time = data.data.createTime;
                        //总额
                        $("#span1").text(data.data.payment);
                        //订单号
                        $("#span2").text(data.data.orderNo);
                        //保密手机号码
                        var receiverMobile = "";
                        for (var i = 0; i < data.data.shippingVo.receiverMobile.length; i++) {
                            if (i > 2 && i < 7) {
                                receiverMobile += "*";
                            } else {
                                receiverMobile += data.data.shippingVo.receiverMobile[i];
                            }
                        }
                        //收货信息
                        var str = data.data.shippingVo.receiverName + " "
                            + receiverMobile + " "
                            + data.data.shippingVo.receiverProvince
                            + data.data.shippingVo.receiverCity
                            + data.data.shippingVo.receiverDistrict
                            + data.data.shippingVo.receiverAddress
                        $("#span3").text(str);
                        //商品信息
                        var str1 = "";
                        for (var i = 0; i < data.data.orderItemVoList.length; i++) {
                            str1 += "<p>" + data.data.orderItemVoList[i].productName + "&emsp;"
                                + data.data.orderItemVoList[i].productDetail + "&nbsp;"
                                + data.data.orderItemVoList[i].productColor + "&emsp;×&nbsp;"
                                + data.data.orderItemVoList[i].quantity + "</p>"
                        }
                        $("#div1").html(str1);
                        //计时器，60分钟后关闭订单
                        t = window.setInterval(function () {
                            refreshCount(time);
                        }, 100);
                    } else {
                        alert("加载订单数据失败！" + data.msg);
                    }
                },
                dataType: "JSON"
            })
        })

        //订单60分钟后取消（计时显示）
        function refreshCount() {
            if ($("#span4").text() == "0分钟") {
                alert("您的订单因超时未支付已被取消！");
                location.href = "orderList.jsp";
            }
            var date = new Date(time);
            var date1 = new Date();
            var time1 = date.getTime();
            var time2 = date1.getTime();
            var time3 = 60 - Math.round((time2 - time1) / (1000 * 60));
            if (time3 <= 0) {
                $("#span4").text(0 + "分钟");
                return;
            }
            $("#span4").text(time3 + "分钟");

        }

        /**
         *  获取URL参数
         */
        function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = decodeURI(window.location.search).substr(1).match(reg);  //匹配目标参数
            if (r != null)
            //返回参数值
                return unescape(r[2]);
            return null;
        }

        /**
         * 如果未登录，则转到登录界面
         */
        function on1() {
            if ($("#dl").text() == "你好，请登录") {
                //隐藏下拉菜单
                $("ul").hide();
                window.location.href = "denglu1.jsp";
            }
        }

        /**
         * 退出登录
         */
        function logout() {
            $.ajax({
                type: "post",
                url: "/user/logout",
                success: function (data) {
                    if (data.status == 0) {
                        location.href = "zhuye.jsp";
                    } else {
                        alert("退出登录失败！" + data.msg);
                    }
                },
                dataType: "JSON"
            })
        }

        /**
         * 支付
         */
        function zf(th) {
            var way = $(th).val();
            if (way == "支付宝") {
                location.href = "zhifubao.jsp?orderNo=" + orderNo;
            }
        }

        /**
         * 点击我的订单
         */
        function orderList(){
            if ("${current_user}" == "") {
                location.href="denglu1.jsp";
            }else {
                location.href="orderList.jsp";
            }
        }
    </script>
</head>

<body>
<div class="container-fluid dd">
    <!--导航栏-->
    <div class="row d1">
        <div class="col-md-1 col-lg-1 col-xs-1 col-sm-1 d1-1">
            <a href=""><img src="img/zhuce1.png"/></a>
        </div>
        <div class="col-md-8 col-lg-8 col-xs-8 col-sm-10 d1-2">
            <h2 class="hh1">支付订单&nbsp;&nbsp;</h2>
        </div>
        <div class="col-md-3 col-lg-3 col-xs-3 col-sm-1 d1-3">
            <div class="d1-2-1 dropdown">
                <button class="bu1" id="dLabel" onclick="on1()" type="button" data-toggle="dropdown"
                        aria-haspopup="true"
                        aria-expanded="false">
                   <span id="dl">
                        <c:if test="${!empty current_user}">${current_user.username}</c:if>
                        <c:if test="${empty current_user}">
                            你好，请登录
                        </c:if>
                    </span>
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" aria-labelledby="dLabel">
                    <li>
                        <a class="a2" href="#">个人中心</a>
                    </li>
                    <li>
                        <a class="a2" href="#">评价晒单</a>
                    </li>
                    <li>
                        <a class="a2" href="#">我的喜欢</a>
                    </li>
                    <li>
                        <a class="a2" href="#">小米账户</a>
                    </li>
                    <li>
                        <a class="a2" onclick="logout()">退出登录</a>
                    </li>
                </ul>
            </div>
            <div class="d1-4">
                <span class="sp1">|</span>
                <a class="a1" onclick="orderList()">我的订单</a>
            </div>
        </div>
    </div>
    <!--订单信息-->
    <div class="row d2">
        <div class="d2-1">
            <div class="d2-1-1">
                <span id="sp2">
                    √
                </span>
            </div>
            <div class="d2-1-2">
                <div class="d2-1-2-1">
                    <p class="sp3">
                        订单提交成功！去付款咯~
                    </p>
                    <p class="sp4">
                        应付总额：
                        <span class="sp5" id="span1">
                        </span>
                        <span class="sp6">
                            元
                        </span>
                    </p>
                </div>
                <p class="sp7">
                    请在
                    <span class="sp6" id="span4">
                    </span>
                    内完成支付，超时后将取消订单
                </p>
                <hr/>
                <div class="d2-1-2-2">
                    <p class="">
                        订单号：&nbsp;&nbsp;&nbsp;&nbsp;
                        <span class="sp6" id="span2">
                        </span>
                    </p>
                    <p>
                        收货信息：
                        <span id="span3">
                        </span>
                    </p>
                    <div class="d2-1-2-1">
                        <p>
                            商品信息：&nbsp;
                        </p>
                        <div id="div1">
                        </div>
                    </div>
                    <p>
                        发票信息：
                        <span>
                        电子发票 个人
                    </span>
                    </p>
                </div>
            </div>
        </div>

    </div>
    <!-- 付款 -->
    <div class="d2">
        <div class="d3-1">
            <h3 class="hh2">支付方式</h3>
            <div class="d3-1-1">
                <hr/>
                <h4 class="hh2">支付平台</h4>
                <button id="zfb" onclick="zf(this)" value="支付宝">
                    <img id="img1" src="https://t.alipayobjects.com/tfscom/T1Z5XfXdxmXXXXXXXX.png"/>
                    <span id="span5">
                		支付宝
                	</span>
                </button>
            </div>
        </div>
    </div>
    <%@include file="bottom.jsp" %>
</div>
</body>

</html>