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

            //获取购物车商品列表
            $.ajax({
                type: "post",
                url: "/cart/list",
                success: function (data) {
                    if (data.status == 0) {
                        list(data);
                    } else {
                        alert("获取数据失败，" + data.msg);
                    }
                },
                dataType: "json"
            })

        })


        /**
         * 显示购物车商品数据
         */
        function list(data) {
            //判断购物车是否为空
            if (data.data.cartProductVos == "") {
                var str = "<th> <h1 style='color: #949da8'>您的购物车还是空的！</h1><a id='a1'href='zhuye.jsp'>马上去购物</a></th>"
                $("#table1").html(str);
                $("#div1").hide();
            } else {
                $("#div1").show();
                //选中商品数量
                var checkedQuantity = 0;
                var str = "<tr class='tr1'>" +
                    "                    <th class='col-lg-2 col-md-2'>" +
                    "                        <div class='j-check'>" +
                    "                            <input type='checkbox' id='allCheck' name='allCart' onclick='check(this)'/>" +
                    "                            <label><span style='display: block; width: 110px;'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;全选</span></label>" +
                    "                        </div>" +
                    "                    </th>" +
                    "                    <th class='col-lg-4 col-md-4'>" +
                    "                        商品名称" +
                    "                    </th>" +
                    "                    <th>" +
                    "                        单价" +
                    "                    </th>" +
                    "                    <th class='col-lg-3 col-md-3'>" +
                    "                        数量" +
                    "                    </th>" +
                    "                    <th class='col-lg-1 col-md-1'>" +
                    "                        小计" +
                    "                    </th>" +
                    "                    <th class='col-lg-1 col-md-1'>" +
                    "                        操作" +
                    "                    </th>" +
                    "                </tr>";
                //遍历商品
                for (var i = 0; i < data.data.cartProductVos.length; i++) {
                    if (data.data.cartProductVos[i].productChecked == 1) {
                        checkedQuantity += data.data.cartProductVos[i].quantity;
                    }
                    if (data.data.cartProductVos[i].productChecked == 1) {
                        str += "<tr class='tr2'><td><div class='i-check'><input value='"
                            + data.data.cartProductVos[i].productId
                            + "' type='checkbox' name='cart'checked='checked' onclick='check1(this)'/><label></label> <img class='img1' src='"
                            + data.data.cartProductVos[i].productMainImage
                            + "'/> </div> </td> <td> <h4>"
                            + data.data.cartProductVos[i].productName + "&nbsp;"
                            + data.data.cartProductVos[i].productDetail + "&nbsp;"
                            + data.data.cartProductVos[i].productColor
                            + "</h4> </td> <td> <h4>"
                            + data.data.cartProductVos[i].productPrice + "元"
                            + "</h4> </td> <td> <div class='d2-1-1 row'> <button class='bu2 col-lg-3 col-md-3' value='"
                            + data.data.cartProductVos[i].productId
                            + "'onclick='dec(this)'><span class='sp2'>-</span></button><div class='d2-1-1-1 col-lg-6 col-md-6'> <span class='sp2'>"
                            + data.data.cartProductVos[i].quantity
                            + "</span> </div> <button class='bu2 col-lg-3 col-md-3' value='"
                            + data.data.cartProductVos[i].productId
                            + "' onclick='add(this)'> <span class='sp2'>+</span></button><button value='"
                            + data.data.cartProductVos[i].quantity
                            + "' style='display: none'></button> </div> </td> <td> <h4 class='hh44' id='hh4'>"
                            + data.data.cartProductVos[i].productTotalPrice + "元"
                            + "</h4> </td> <td> <span class='sp2'><button class='bu3' onclick='del(this)' value='"
                            + data.data.cartProductVos[i].productId
                            + "'>×</button></span> </td> </tr>"
                    } else {
                        str += "<tr class='tr2'><td><div class='i-check'><input value='"
                            + data.data.cartProductVos[i].productId
                            + "' type='checkbox' name='cart' onclick='check1(this)'/><label></label> <img class='img1' src='"
                            + data.data.cartProductVos[i].productMainImage
                            + "'/> </div> </td> <td> <h4>"
                            + data.data.cartProductVos[i].productName + "&nbsp;"
                            + data.data.cartProductVos[i].productDetail + "&nbsp;"
                            + data.data.cartProductVos[i].productColor
                            + "</h4> </td> <td> <h4>"
                            + data.data.cartProductVos[i].productPrice + "元"
                            + "</h4> </td> <td> <div class='d2-1-1 row'> <button class='bu2 col-lg-3 col-md-3' value='"
                            + data.data.cartProductVos[i].productId
                            + "'onclick='dec(this)'><span class='sp2'>-</span></button><div class='d2-1-1-1 col-lg-6 col-md-6'> <span class='sp2'>"
                            + data.data.cartProductVos[i].quantity
                            + "</span> </div> <button class='bu2 col-lg-3 col-md-3' value='"
                            + data.data.cartProductVos[i].productId
                            + "' onclick='add(this)'> <span class='sp2'>+</span></button><button value='"
                            + data.data.cartProductVos[i].quantity
                            + "' style='display: none'></button> </div> </td> <td> <h4 class='hh44' id='hh4'>"
                            + data.data.cartProductVos[i].productTotalPrice + "元"
                            + "</h4> </td> <td> <span class='sp2'><button class='bu3' onclick='del(this)' value='"
                            + data.data.cartProductVos[i].productId
                            + "'>×</button></span> </td> </tr>"
                    }
                    //判断商品数量是否达到库存
                    if (data.data.cartProductVos[i].limitQuantity != "LIMIT_NUM_SUCCESS") {
                        alert("商品达到可以购买的最大数量！");
                    }
                }
                $("#table1").html(str);

                //购物车商品数量
                $.ajax({
                    type: "post",
                    url: "/cart/getCartProductCount",
                    success: function (data) {
                        if (data.status == 0) {
                            $("#span1").html("&nbsp;" + data.data + "&nbsp;");
                        } else {
                            alert("购物车商品数量获取失败！" + data.msg);
                        }
                    },
                    dataType: "json"
                })

                //选中商品数量
                $("#sp4").text(checkedQuantity);
                //判断是否全选
                if (data.data.allChecked == true) {
                    $("#allCheck").prop("checked", true);
                } else {
                    $("#allCheck").prop("checked", false);
                }
                //合计
                $("#span2").text(data.data.cartTotalPrice);
                var hj = $("#span2").text();
                //如果合计为0，则不能结算
                heji(hj);

            }
        }


        /**
         * 如果合计为0，则不能结算
         */

        function heji(hj) {
            //修改按钮样式
            if (hj == 0) {
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
         * 删除勾选的购物车商品
         */
        function del() {
            //获取已选中商品的productIds
            var productIds = new Array();
            $("input[name = 'cart']:checked").each(function () {
                productIds.push($(this).val());
            })
            if (productIds == ""){
                alert("您未勾选任何商品！");
                return;
            }
            //弹出删除确认框
            var t = confirm("确认移除已勾选的商品吗？");
            if (t == true) {
                $.ajax({
                    type: "post",
                    url: "/cart/deleteProduct/" + productIds,
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("移除购物车商品失败！" + data.msg);
                        }
                    },
                    dataType: "json"
                })
            }
        }

        /**
         * 操作商品数量
         */
        //点击"-"按钮商品数量-1
        function dec(th) {
            //获取当前商品数量
            var v = $(th).next().find("span").text();
            //当前商品数量-1
            var quantity = parseInt(v) - 1;
            //获取当前商品编号
            var productId = $(th).val();
            //判断-1后商品数量是否<1，如果<1则不能减少
            if (quantity >= 1) {
                $.ajax({
                    type: "post",
                    url: "/cart/update/" + productId + "/" + quantity,
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("修改数量失败，" + data.msg);
                        }
                    },
                    dataType: "Json"
                })
            }
        }

        //点击"+"按钮商品数量+1
        function add(th) {
            //获取当前商品数量
            var v = $(th).prev().find("span").text();
            //当前商品数量+1
            var quantity = parseInt(v) + 1;
            //获取当前商品编号
            var productId = $(th).val();
            $.ajax({
                type: "post",
                url: "/cart/update/" + productId + "/" + quantity,
                success: function (data) {
                    if (data.status == 0) {
                        list(data);
                    } else {
                        alert("修改数量失败，" + data.msg);
                    }
                },
                dataType: "Json"
            })

        }

        /**
         * 复选框操作
         */

        //全选和全不选
        function check(th) {
            if (th.checked) {
                //全选
                $.ajax({
                    type: "post",
                    url: "/cart/selectAll",
                    //获取操作结果
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("操作失败，" + data.msg);
                        }
                    },
                    dataType: "Json"
                })
            } else {
                //全不选
                $.ajax({
                    type: "post",
                    url: "/cart/unselectAll",
                    //获取操作结果
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("操作失败，" + data.msg);
                        }
                    },
                    dataType: "Json"
                })
            }
        }

        //选中或不选单个复选框
        function check1(th) {
            var id = $(th).val();
            if (th.checked) {
                //选中
                $.ajax({
                    type: "post",
                    url: "/cart/select/" + id,
                    //获取操作结果
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("操作失败，" + data.msg);
                        }
                    },
                    dataType: "Json"
                })
            } else {
                //取消选中
                $.ajax({
                    type: "post",
                    url: "/cart/unselect/" + id,
                    //获取操作结果
                    success: function (data) {
                        if (data.status == 0) {
                            list(data);
                        } else {
                            alert("操作失败，" + data.msg);
                        }
                    },
                    dataType: "Json"
                })
            }
        }

        /**
         * 点击结算按钮
         */
        function jiesuan() {
            location.href = "dingdan.jsp";
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
                        alert("退出登录失败！"+data.msg);
                    }
                },
                dataType: "JSON"
            })
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
    <div class="row d2">
        <div class="col-lg-12 col-md-12 d2-1">
            <table id="table1" class="tab1">

                <tr class='tr1'>
                    <th class='col-lg-2 col-md-2'>
                        <div class='j-check'>
                            <input type='checkbox' name='allCart' onclick='check(this)'/>
                            <label><span style='display: block; width: 110px;'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;全选</span></label>
                        </div>
                    </th>
                    <th class='col-lg-4 col-md-4'>
                        商品名称
                    </th>
                    <th>
                        单价
                    </th>
                    <th class='col-lg-3 col-md-3'>
                        数量
                    </th>
                    <th class='col-lg-1 col-md-1'>
                        小计
                    </th>
                    <th class='col-lg-1 col-md-1'>
                        操作
                    </th>
                </tr>
            </table>
        </div>

    </div>

    <div class="d3 row">
        <div id="div1" class="d3-1">
            <div class="col-lg-4 col-md-4 d3-1-1">
                <a class="a3" href="zhuye.jsp">继续购物</a>
                <span class="sp3">&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;</span>
                <span class="sp1">共<span id="span1" class="sp4"></span>件商品，已选择
						<span id="sp4" class="sp4">0</span>&nbsp;件</span>
            </div>
            <div class="col-lg-4 col-md-4">
            </div>
            <div class="col-lg-2 col-md-2">
                <span class="sp5" id="hj">合计：<span id="span2" class="sp6">0</span>&nbsp;元</span>
            </div>
            <div class="col-lg-2 col-md-2 d3-1-2 d3-1-2">
                    <span id="sp7" class="sp77"><button id="bu4" class="bu44"
                                                        onclick="jiesuan()">去结算</button></span>
            </div>
        </div>
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