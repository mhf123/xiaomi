<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
        /**
         * 如果未登录，则转到登录界面
         */
        function on1() {
            if ($("#dl").text() == "你好，请登录"){
                //隐藏下拉菜单
                $("ul").hide();
                window.location.href = "denglu1.jsp";
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
                <button class="bu1" id="dLabel" type="button" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">
                    <c:if test="${iflogin == 1}">${sessionScope.name}</c:if>
                    <c:if test="${empty iflogin}">
                        <span id="dl">你好，请登录</span>
                    </c:if>
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
                        <a class="a2" href="LogOutServlet">退出登录</a>
                    </li>
                </ul>
            </div>
            <div class="d1-4">
                <span class="sp1">|</span>
                <a class="a1" href="">我的订单</a>
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
                        <span class="sp5">
                            ${sprice}
                        </span>
                        <span class="sp6">
                            元
                        </span>
                    </p>
                </div>
                <p class="sp7">
                    请在
                    <span class="sp6">
                        1小时50分钟
                    </span>
                    内完成支付，超时后将取消订单
                </p>
                <hr/>
                <div class="d2-1-2-2">
                    <p class="">
                        订单号：&nbsp;&nbsp;&nbsp;&nbsp;
                        <span class="sp6">
                            ${dingdan.get(0)[0]}
                        </span>
                    </p>
                    <p>
                        收货信息：
                        <span>
                            ${dingdan.get(0)[6]}&nbsp;${dingdan.get(0)[7]}&nbsp;${dingdan.get(0)[8]}
                        </span>
                    </p>
                    <div class="d2-1-2-1">
                        <p>
                            商品信息：&nbsp;
                        </p>
                        <div>
                            <c:forEach items="${dingdan}" var="dd">
                                <p>
                                    ${dd[1]}&emsp;${dd[2]}&nbsp;${dd[3]}&emsp;×&nbsp;${dd[5]}
                                </p>
                            </c:forEach>
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
            </div>
        </div>
    </div>
    <%@include file="bottom.jsp" %>
</div>
</body>

</html>