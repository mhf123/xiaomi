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
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css"/>
    <script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="css/gouwuche.css"/>

    <script type="text/javascript">

        /**
         * 网页加载完成后
         */
        $(document).ready(function () {
            //如果合计为0，则不能结算
            heji();
            //重置所有复选框为未选中
            $("input:checkbox").prop("checked", false);
        })

        //计算选中几种商品
        function cc() {
            var m = 0;
            for (var i = 0; i < $("[name = cart]:checkbox").length; i++) {
                //如果有一个选中，则种数+1
                if ($("[name = cart]:checkbox:eq(" + i + ")").is(":checked") == true) {
                    m += 1;
                }
            }
            //显示到页面相应位置
            $("#sp4").text(m);
        }

        /**
         * 如果合计为0，则不能结算
         */

        function heji() {
            //获取总计值
            var hj = $("#hj").text();
            hj = hj.substring(3, hj.length - 2);
            //修改按钮样式
            if (hj == "0") {
                $("#sp7").attr("class", "sp77");
                $("#bu4").attr("class", "bu44");
                $("#bu4").attr("disabled", true);
            } else {
                $("#sp7").attr("class", "sp7");
                $("#bu4").attr("class", "bu4");
                $("#bu4").attr("disabled", false);
            }

        }

        /**
         * 修改合计
         */
        function sum(bm, am) {
            //获取合计价钱
            var hj = $("#hj").text();
            hj = hj.substring(3, hj.length - 1);
            //让合计价钱-修改前的总价后+修改后的总价,然后重新显示
            $("#hj").html("<span class='sp5' id='hj'>合计：<span class='sp6'>" + (parseInt(hj) - parseInt(bm) + parseInt(am)) + "&nbsp;</span>元</span>");
        }

        /**
         * 删除点击的购物车商品
         */
        function del(th) {
            //获取商品编号
            var code = $(th).val();
            //弹出删除确认框
            var t = confirm("确认删除吗？")
            var hr = "DeleteCartServlet?code=" + code;
            if (t == true) {
                //转到后台
                window.location.href = hr;
            }
        }

        /**
         * 操作商品数量
         */
        //点击"-"按钮商品数量-1
        function dec(th) {
            //获取当前商品数量,并转成int型
            var v = $(th).next().find("span").text();
            var num = parseInt(v);
            //获取当前商品编号
            var code = $(th).val();
            //判断商品数量是否等于1，如果为1则不能减少
            if (num > 1) {
                //传回商品编号，使后台购物车商品数量-1
                $.ajax({
                    type: "post",
                    url: "/xiaomi/DecCartServlet",
                    data: {
                        "code": code
                    },
                    //获取商品数量的json
                    success: function (data) {
                        //商品数量-1
                        code = code - 1;
                        //页面显示商品数量-1
                        $(th).next().find("span").text(data[0].number);
                        //获取商品单价
                        var a = $(th).parent().parent().prev().find("h4").text();
                        var price = a.substring(0, a.length - 1);
                        //获取商品数量
                        var number = $(th).next().find("span").text();
                        //获取商品修改前的总价
                        var bm = $(th).parent().parent().next().find("h4").text();
                        bm = bm.substring(0, bm.length - 1);
                        //更改商品总价,并获取
                        $(th).parent().parent().next().find("h4").text(price * number + "元");
                        var am = $(th).parent().parent().next().find("h4").text();
                        am = am.substring(0, am.length - 1);
                        //判断当前商品是否选中
                        if ($(th).parent().parent().prev().prev().prev().find("input").is(":checked")) {
                            //修改合计
                            sum(bm, am);
                        }
                        //判断合计是否为0,如果是则改变按钮样式
                        heji();

                    },
                    dataType: "Json"
                })
            }
        }

        //点击"+"按钮商品数量+1
        function add(th) {
            //获取当前商品数量,并转成int型
            var v = $(th).prev().find("span").text();
            var num = parseInt(v);
            //获取当前商品库存和商品编号,并将库存转成int型
            var code = $(th).val();
            var s = $(th).next().val();
            var stock = parseInt(s);
            //判断商品数量+1后是否大于库存，如果大于，则增加失败,否则数量+1
            if (num + 1 > stock) {
                alert("库存不足！");
            } else {
                //传回商品编号，使后台购物车商品数量+1
                $.ajax({
                    type: "post",
                    url: "/xiaomi/AddCartServlet",
                    data: {
                        "code": code
                    },
                    //获取操作结果
                    success: function (data) {
                        //获取商品数量的json
                        $(th).prev().find("span").text(data[0].number);
                        //获取商品单价
                        var a = $(th).parent().parent().prev().find("h4").text();
                        var price = a.substring(0, a.length - 1);
                        //获取商品数量
                        var number = $(th).prev().find("span").text();
                        //获取商品修改前的总价
                        var bm = $(th).parent().parent().next().find("h4").text();
                        bm = bm.substring(0, bm.length - 1);
                        //更改商品总价,并获取
                        $(th).parent().parent().next().find("h4").text(price * number + "元");
                        var am = $(th).parent().parent().next().find("h4").text();
                        am = am.substring(0, am.length - 1);
                        //判断当前商品是否选中
                        if ($(th).parent().parent().prev().prev().prev().find("input").is(":checked")) {
                            //修改合计
                            sum(bm, am);
                        }
                    },
                    dataType: "Json"
                })
            }
        }

        /**
         *
         * 复选框操作
         */

        //全选和全不选
        function check(th) {
            if (th.checked) {
                //全选
                $("[name = cart]:checkbox").prop("checked", true);
                //所有商品的总价变量
                var sum = 0;
                //遍历购物车商品，获得所有商品总价
                for (var i = 0; i < $(".hh44").length; i++) {
                    //获取此商品总价
                    var m = $(".hh44:eq(" + i + ")").text();
                    m = m.substring(0, m.length - 1);
                    // 遍历计算总价和
                    sum += parseInt(m);
                }
                //修改后的合计价钱显示到相应位置
                $("#hj").html("<span class='sp5' id='hj'>合计：<span class='sp6'>" + sum + "&nbsp;</span>元</span>");
                //判断合计是否为0,如果是则改变按钮样式
                heji();
                //计算选中的商品种类数
                cc();
            } else {
                //全不选
                $("[name = cart]:checkbox").prop("checked", false);
                //修改后合计价钱为0，并显示到相应位置
                $("#hj").html("<span class='sp5' id='hj'>合计：<span class='sp6'>0&nbsp;</span>元</span>");
                //判断合计是否为0,如果是则改变按钮样式
                heji();
                //计算选中的商品种类数
                cc();
            }
        }

        //选中或不选单个复选框
        function check1(th) {
            //选中
            if (th.checked) {
                //判断是不是全部复选框都选中，如果是，选中全选框
                var flag = true;
                //遍历复选框，判断是否全部选中
                for (var i = 0; i < $("[name = cart]:checkbox").length; i++) {
                    //如果有一个未选中，则退出循环
                    if ($("[name = cart]:checkbox:eq(" + i + ")").is(":checked") == false) {
                        flag = false;
                        break;
                    }
                }
                //如果全部选中则选中全选框
                if (flag == true) {
                    $("[name = allCart]:checkbox").prop("checked", true);
                }
                //获取此商品总价
                var m = $(th).parent().parent().next().next().next().next().find("h4").text();
                m = m.substring(0, m.length - 1);
                //获取合计价钱
                var hj = $("#hj").text();
                hj = hj.substring(3, hj.length - 1);
                //修改后的价钱显示到相应位置
                $("#hj").html("<span class='sp5' id='hj'>合计：<span class='sp6'>" + (parseInt(hj) + parseInt(m)) + "&nbsp;</span>元</span>");
                //判断合计是否为0,如果是则改变按钮样式
                heji();
                //计算选中的商品种类数
                cc();

            } else {
                //不选中全选框
                $("[name = allCart]:checkbox").prop("checked", false);
                //获取此商品总价
                var m = $(th).parent().parent().next().next().next().next().find("h4").text();
                m = m.substring(0, m.length - 1);
                //获取合计价钱
                var hj = $("#hj").text();
                hj = hj.substring(3, hj.length - 1);
                //修改后的价钱显示到相应位置
                $("#hj").html("<span class='sp5' id='hj'>合计：<span class='sp6'>" + (parseInt(hj) - parseInt(m)) + "&nbsp;</span>元</span>");
                //判断合计是否为0,如果是则改变按钮样式
                heji();
                //计算选中的商品种类数
                cc();
            }
        }

        /**
         * 点击结算按钮
         */
        function jiesuan() {
            //声明商品编号数组变量
            var cartCode = new Array();
            //遍历复选框，添加选中的商品信息
            for (var i = 0; i < $("[name = cart]:checkbox").length; i++) {
                //如果选中，添加商品编号
                if ($("[name = cart]:checkbox:eq(" + i + ")").is(":checked") == true) {
                    cartCode.push($("[name = cart]:checkbox:eq(" + i + ")").val());
                }
            }
            var hr = "ClearingServlet?codes=" + cartCode;
            location.href = hr;

           /* //判断是否已经有订单，如果有，需要先处理之前订单
            $.ajax({
                type: "post",
                url: "/xiaomi/CheckOrderServlet",
                data: {
                    "code": 1
                },
                //获取操作结果
                success: function (data) {
                    //如果有未处理订单提示前往处理
                    if (data == "false") {
                        var t = confirm("您有未处理的订单，是否前往结算？")
                        if (t == true) {
                            var str = "ProcessOrderServlet";
                            window.location.href = str;
                        }
                    } else {
                        //声明商品编号数组变量
                        var cartCode = new Array();
                        //遍历复选框，添加选中的商品信息
                        for (var i = 0; i < $("[name = cart]:checkbox").length; i++) {
                            //如果选中，添加商品编号
                            if ($("[name = cart]:checkbox:eq(" + i + ")").is(":checked") == true) {
                                cartCode.push($("[name = cart]:checkbox:eq(" + i + ")").val());
                            }
                        }
                        var hr = "ClearingServlet?codes=" + cartCode;
                        location.href = hr;
                    }
                },
                dataType: "text"
            })
*/

        }
    </script>
</head>

<body>
<div class="container-fluid dd">
    <div class="row d1">
        <div class="col-md-1 col-lg-1 col-xs-1 col-sm-1 d1-1">
            <a href=""><img src="img/zhuce1.png"/></a>
        </div>
        <div class="col-md-8 col-lg-8 col-xs-8 col-sm-10 d1-2">
            <h2 class="hh1">我的购物车&nbsp;&nbsp;</h2>
            <span class="sp1">温馨提示：产品是否购买成功，以最终下单为准哦，请尽快结算</span>
        </div>
        <div class="col-md-3 col-lg-3 col-xs-3 col-sm-1 d1-3">
            <div class="d1-2-1 dropdown">
                <button class="bu1" id="dLabel" type="button" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">
                    <span>
                        <c:if test="${iflogin == 1}">${sessionScope.name}</c:if>
                        <c:if test="${empty iflogin}">你好，请登录</c:if>
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
    <div class="row d2">
        <div class="col-lg-12 col-md-12 d2-1">
            <table class="tab1">
                <c:if test="${empty gwc}">
                    <th>
                        <h1 style="color: #949da8">您的购物车还是空的！</h1>
                    </th>
                </c:if>
                <c:if test="${!empty gwc}">
                    <tr class="tr1">
                        <th class="col-lg-2 col-md-2">
                            <div class="j-check">
                                <input type="checkbox" name="allCart" onclick="check(this)"/>
                                <label><span style="display: block; width: 110px;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;全选</span></label>
                            </div>
                        </th>
                        <th class="col-lg-4 col-md-4">
                            商品名称
                        </th>
                        <th>
                            单价
                        </th>
                        <th class="col-lg-3 col-md-3">
                            数量
                        </th>
                        <th class="col-lg-1 col-md-1">
                            小计
                        </th>
                        <th class="col-lg-1 col-md-1">
                            操作
                        </th>
                    </tr>
                    <%--循环遍历购物车--%>
                    <c:forEach items="${gwc}" var="car">
                        <tr class="tr2">
                            <td>
                                    <%--复选框--%>
                                <div class="i-check">
                                    <input value="${car[5]}" type="checkbox" name="cart" onclick="check1(this)"/>
                                    <label></label>
                                    <img class="img1" src="img/gouwuche/gouwuche1-1.png"/>
                                </div>
                            </td>
                            <td>
                                <h4>${car[0]}&nbsp;${car[1]}&nbsp;${car[2]}</h4>
                            </td>
                            <td>
                                <h4>${car[3]}元</h4>
                            </td>
                            <td>
                                <div class="d2-1-1 row">
                                    <button class="bu2 col-lg-3 col-md-3" value="${car[5]}" onclick="dec(this)"><span
                                            class="sp2">-</span></button>
                                    <div class="d2-1-1-1 col-lg-6 col-md-6">
                                        <span class="sp2">${car[4]}</span>
                                    </div>
                                    <button class="bu2 col-lg-3 col-md-3" value="${car[5]}" onclick="add(this)"><span
                                            class="sp2">+</span></button>
                                    <button value="${car[6]}" style="display: none"></button>
                                </div>
                            </td>
                            <td>
                                <h4 class="hh44" id="hh4">${car[3] * car[4]}元</h4>
                            </td>
                            <td>
                                <span class="sp2"><button class="bu3" onclick="del(this)"
                                                          value="${car[5]}">×</button></span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>
        </div>

    </div>

    <div class="d3 row">
        <c:if test="${!empty gwc}">
            <div class="d3-1">
                <div class="col-lg-4 col-md-4 d3-1-1">
                    <a class="a3" href="index.jsp">继续购物</a>
                    <span class="sp3">&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span class="sp1">共<span class="sp4">&nbsp;${count}&nbsp;</span>种商品，已选择
						<span id="sp4" class="sp4">0</span>&nbsp;种</span>
                </div>
                <div class="col-lg-4 col-md-4">
                </div>
                <div class="col-lg-2 col-md-2">
                    <span class="sp5" id="hj">合计：<span class="sp6">0&nbsp;</span>元</span>
                </div>
                <div class="col-lg-2 col-md-2 d3-1-2 d3-1-2">
                    <span id="sp7" class="sp77"><button id="bu4" class="bu44"
                                                        onclick="jiesuan()">去结算</button></span>
                </div>
            </div>
        </c:if>
        <div class="row d3-2">
            <div class="col-lg-4 col-md-4 d3-2-1">
            </div>
            <div class="col-lg-4 col-md-4 d3-2-2">
                <span class="sp7-2">&nbsp;&nbsp;买购物车中商品的人还买了</span>
            </div>
            <div class="col-lg-4 col-md-4 d3-2-1">
            </div>
        </div>
        <div class="row d3-3">
            <div class="d3-3-1">
                <a href=""><img src="img/gouwuche/gouwuche2-1.png"/></a>
            </div>
            <div class="d3-3-2">
            </div>
            <div class="d3-3-1">
                <a href=""><img class="img2" src="img/gouwuche/gouwuche2-2.png"/></a>
                <br/><br/>
                <h5>红米6A 全网通版</h5>
                <h5 class="hh4">599元</h5>
                <button class="bu5" onclick="alert('已成功加入购物车')">加入购物车</button>
            </div>
            <div class="d3-3-2">
            </div>
            <div class="d3-3-1">
                <a href=""><img class="img2" src="img/gouwuche/gouwuche2-3.png"/></a>
                <br/><br/>
                <h5>红米6 全网通版</h5>
                <h5 class="hh4">999元</h5>
                <button class="bu5" onclick="alert('已成功加入购物车')">加入购物车</button>
            </div>
            <div class="d3-3-2">
            </div>
            <div class="d3-3-1">
                <a href=""><img class="img2" src="img/gouwuche/gouwuche2-4.png"/></a>
                <br/><br/>
                <h5>千兆网口多功能转接器</h5>
                <h5 class="hh4">199元</h5>
                <button class="bu5" onclick="alert('已成功加入购物车')">加入购物车</button>
            </div>
            <div class="d3-3-2">
            </div>
            <div class="d3-3-1">
                <a href=""><img class="img2" src="img/gouwuche/gouwuche2-5.png"/></a>
                <br/><br/>
                <h5>13.3"小米笔记本</h5>
                <h5 class="hh4">5199元</h5>
                <button class="bu5" onclick="alert('已成功加入购物车')">加入购物车</button>
            </div>
        </div>
    </div>
    <hr/>
    <%@include file="bottom.jsp" %>
</div>
</body>

</html>