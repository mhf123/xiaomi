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
    <script src="js/zhuye.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="css/xiangqing.css"/>

    <script type="text/javascript">
        //id、名字、版本、颜色的全局变量
        var id, name, detail, color;

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
         * 网页加载完成后加载数据
         */
        $(document).ready(function () {
            //获取url参数
            name = getUrlParam("name");
            //加载商品数据
            $.ajax({
                type: "post",
                url: "/product/listByDemand/" + name,
                success: function (data) {
                    if (data.status == 0) {
                        $("#span1").text(data.data.list[0].name);
                        $("#cname").text(data.data.list[0].name);
                        $("#span2").text(data.data.list[0].subtitle);

                        //加载版本数据
                        var str = "";
                        for (var i = 0; i < data.data.list.length; i++) {
                            str += "<button class='d4-2-3-1' onclick='banben1(this)' value='"
                                + data.data.list[i].detail
                                + "'><span class='sp7'>&nbsp;&nbsp;"
                                + data.data.list[i].detail
                                + "</span></button>";
                        }
                        $("#div2").html(str);

                        //加载颜色数据
                        banben1(".d4-2-3-1:nth-of-type(1)");
                    } else {
                        alert("加载商品数据失败！" + data.msg);
                    }
                },
            })
            //获取购物车商品数量
            $.ajax({
                type: "post",
                url: "/cart/getCartProductCount",
                success: function (data) {
                    if (data.status == 0) {
                        $("#gou").text("购物车(" + data.data + ")");
                    }
                },
                dataType: "JSON"
            })
            //调用点击版本的函数
            banben1(".d4-2-3-1:nth-of-type(1)");
        })

        /**
         * 通过点击商品版本，获取商品版本对应的颜色并显示在页面，并默认选中相应颜色
         */
        function banben1(th) {
            //获取商品版本
            detail = $(th).val();
            //版本选中样式
            $(".d4-2-3-1").css({
                "border-color": "#DBDBDB",
                "color": "black"
            });
            $(th).css({
                "border-color": "#FF6700",
                "color": "#FF6700"
            });
            $.ajax({
                type: "post",
                url: "/product/listByDemand/" + name,
                data: {
                    "detail": detail,
                },
                //获取商品版本对应的颜色和库存的json，并显示在页面
                success: function (data) {
                    if (data.status == 0) {
                        var str = "";
                        //遍历当前版本商品颜色
                        for (var i = 0; i < data.data.list.length; i++) {
                            //库存不为0的样式
                            if (data.data.list[i].stock != 0) {
                                str += "<button class='d4-2-4-1' onclick='color1(this)' value='"
                                    + data.data.list[i].color2
                                    + "'><div style='background-color:" + data.data.list[i].color1 + "' class='d4-2-4-1-1'></div><h4>"
                                    + data.data.list[i].color2 + "</h4></button>";
                            }
                        }
                        for (var i = 0; i < data.data.list.length; i++) {
                            //判断库存是否为0，如果为0修改样式
                            if (data.data.list[i].stock == 0) {
                                str += "<button class='d4-2-4-2' onclick='color1(this)' value='"
                                    + data.data.list[i].color2
                                    + "'><div style='background-color:" + data.data.list[i].color1 + "' class='d4-2-4-1-1'></div><h4>"
                                    + data.data.list[i].color2 + "</h4></button>";
                            }
                        }

                        $("#d4-2-4").html(str);

                        var i;
                        //遍历当前版本所有颜色
                        for (i = 1; i <= $(".d4-2-4-1").length; i++) {
                            //如果此版本的颜色中有上一次选中的颜色，则选中此颜色
                            if (color == $(".d4-2-4-1:nth-of-type(" + i + ")")
                                .text()) {
                                //给颜色全局变量赋值为上一次选中颜色
                                color = $(".d4-2-4-1:nth-of-type(" + i + ")").text();
                                //所有颜色变回原来样式
                                $(".d4-2-4-1").css({
                                    "border-color": "#DBDBDB",
                                    "color": "black"
                                });
                                //改变第上一次选中的颜色样式
                                $(".d4-2-4-1:nth-of-type(" + i + ")").css({
                                    "border-color": "#FF6700",
                                    "color": "#FF6700"
                                });
                                //选中颜色
                                color1(".d4-2-4-1:nth-of-type(" + i + ")");
                                return;
                            }
                        }
                        //如果此版本颜色中没有上一次选中的颜色且有库存不为零的颜色，则选中第一个库存不为0的颜色
                        if (i > $(".d4-2-4-1").length && $(".d4-2-4-1").length != 0) {
                            //给颜色全局变量赋值为第一个颜色
                            color = $(".d4-2-4-1:nth-of-type(1)").text();
                            //改变第一个颜色样式
                            $(".d4-2-4-1:nth-of-type(1)").css({
                                "border-color": "#FF6700",
                                "color": "#FF6700"
                            });
                            //选中颜色
                            color1(".d4-2-4-1:nth-of-type(1)");
                            //如果没有库存不为0的颜色，则选中库存为0的第一个颜色
                        } else if ($(".d4-2-4-1").length == 0) {
                            //给颜色全局变量赋值为库存为0的第一个颜色
                            color = $(".d4-2-4-2:nth-of-type(1)").text();
                            //修改选中颜色的样式
                            $(".d4-2-4-2:nth-of-type(1)").css({
                                "border-color": "#FF6700",
                                "color": "#FF6700"
                            });
                            //选中颜色
                            color1(".d4-2-4-2:nth-of-type(1)");
                        }
                    }
                },
                dataType: "JSON"
            })
        }

        /**
         * 通过点击商品颜色，获取商品库存和价格并显示在页面
         */
        function color1(th) {
            //获取商品颜色
            color = $(th).val();
            //颜色选中样式
            $(".d4-2-4-1").css({
                "border-color": "#DBDBDB",
                "color": "black"
            });
            $(".d4-2-4-2").css({
                "border-color": "#DBDBDB",
                "color": "black"
            });
            $(th).css({
                "border-color": "#FF6700",
                "color": "#FF6700"
            });
            $.ajax({
                type: "post",
                url: "/product/listByDemand/" + name,
                //把商品名称、颜色和版本的数据穿到后台
                data: {
                    "detail": detail,
                    "color": color
                },
                //获取商品价钱、库存和编号并将价钱和库存显示在页面相应位置
                success: function (data) {
                    if (data.status == 0) {
                        id = data.data.list[0].id;
                        //加载轮播图片
                        var imgs = data.data.list[0].subImages.split(",");
                        var i = 0;
                        $(".img3").each(function () {
                            $(this).attr("src", imgs[i++]);
                        })
                        //更新价格
                        $("#sp7").text(data.data.list[0].price + "元");
                        //修改加入购物车按钮和库存显示
                        if (data.data.list[0].stock == 0) {
                            $("#kc").text("");
                            $("#a7").text("暂时缺货");
                            $("#sp9").text("到货通知");
                            $("#gwc").attr("value", "到货通知");
                            $("#gwc").attr("class", "d4-2-5-0 col-lg-6 col-md-6");
                        } else {
                            $("#kc").text("(库存 " + data.data.list[0].stock + ")");
                            $("#sp9").text("加入购物车");
                            $("#gwc").attr("value", "加入购物车");
                            $("#a7").text("有现货");
                            $("#gwc").attr("class", "d4-2-5-1 col-lg-6 col-md-6");
                        }
                    }
                },
                dataType: "JSON"
            })
        }

        /**
         * 点击加入购物车(到货通知)
         */
        function cart(th) {
            //判断是否登录
            if ("${current_user}" == "") {
                var t = confirm("你还未登录，是否前往登录？")
                if (t == true) {
                    window.location.href = "denglu1.jsp";
                }
            }
            else {
                //判断库存是否为0
                if ($(th).val() == "加入购物车") {
                    $.ajax({
                        type: "post",
                        url: "/cart/add/" + id + "/1",
                        //获取操作结果
                        success: function (data) {
                            //如果操作成功，则弹出是否转到购物车界面的提示框
                            if (data.status == 0) {
                                //获取购物车商品数量
                                $.ajax({
                                    type: "post",
                                    url: "/cart/getCartProductCount",
                                    success: function (data) {
                                        if (data.status == 0) {
                                            $("#gou").text("购物车(" + data.data + ")");
                                        }
                                    },
                                    dataType: "JSON"
                                })

                                var t = confirm("加入购物车成功，是否前往购物车结算？")
                                if (t == true) {
                                    window.location.href = "gouwuche.jsp";
                                }
                            } else {
                                alert(data.msg);
                            }
                        },
                        dataType: "json"
                    })

                } else if ($(th).val() == "到货通知") {
                    alert("到货通知设置成功！")
                }

            }
        }

        /**
         * 点击购物车，如果未登录，则用户确认后转到登录界面
         */

        function on2() {
            if ("${current_user}" == "") {
                var t = confirm("你还未登录，是否前往登录？")
                if (t == true) {
                    window.location.href = "denglu1.jsp";
                }
            }
            else
                window.location.href = "gouwuche.jsp";
        }

        /**
         * 如果未登录，则用户确认后转到登录界面
         */
        function on1() {
            if ("${current_user}" == "") {
                //隐藏下拉菜单
                $("ul").hide();
                window.location.href = "denglu1.jsp";
            }
        }


        /**
         *  搜索提示功能
         */

        //点击其他地方关闭搜索提示框
        function close_xiala() {
            $("#div1").hide();
        }

        //鼠标悬停事件
        function xiala1(th) {
            $(th).css({
                "background": "#DCDCDC",
                "color": "#FF6700"
            })
        }

        //鼠标点击事件
        function xiala2(th) {
            $("#search").val($(th).text());
            $("#div1").hide();
        }

        //鼠标移开事件
        function xiala3(th) {
            $(th).css({
                "background": "white",
                "color": "black"
            })
        }

        //每按一次键盘，进行一次搜索提示
        function fsearch(th) {
            //获取搜索框输入的数据
            var val = $(th).val();
            var str = "";
            $("#div1").show();
            //搜索为空则不提示
            if (val == "") {
                $("#div1").hide();
            }
            $.ajax({
                type: "post",
                url: "/product/suggestList/" + val,
                //把输入的数据穿到后台
                data: {
                    "val": val
                },
                //获取搜索提示的数据并输出
                success: function (data) {
                    if (data.status == 0) {
                        if (data.data.list.length > 0)
                            $("#div1").css("border", "1px solid #A6A6A6");
                        for (var i = 0; i < data.data.list.length; i++)
                            str += "<div style='line-height:30px' onmousemove='xiala1(this)' onclick='xiala2(this)' onmouseout='xiala3(this)'>"
                                + data.data.list[i].name + "</div>";
                        $("#div1").html(str);
                    }
                },
                dataType: "JSON"
            })

        }

        //点击其他地方关闭搜索提示框
        function close_xiala() {
            $("#div1").hide();
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
                        alert("退出登录失败！")
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

<body onclick="close_xiala()">
<div class="container-fluid">
    <div class="d1 row">
        <div class="d1-1">
            <a href="index.jsp" class="a1">小米商城&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">MIUI&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">loT&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">云服务&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">金融&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">有品&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">小爱开放平台&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">政企服务&nbsp;</a> <span class="sp1">|&nbsp;</span>
            <a href="" class="a1">Select Region</a>
        </div>
        <div id="div3">
            <!--下拉式菜单-->
            <div class="d1-2 dropdown">
                <button class="bu1" onclick="on1()" id="dLabel" type="button" value="${current_user.username}"
                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <span id="dl">
                        <c:if test="${!empty current_user}">${current_user.username}</c:if>
                        <c:if test="${empty current_user}">
                            你好，请登录
                        </c:if>
                    </span>
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" aria-labelledby="dLabel">
                    <li><a class="a2" href="#">个人中心</a></li>
                    <li><a class="a2" href="#">评价晒单</a></li>
                    <li><a class="a2" href="#">我的喜欢</a></li>
                    <li><a class="a2" href="#">小米账户</a></li>
                    <li><a class="a2" onclick="logout()">退出登录</a></li>
                </ul>
            </div>
            <span class="sp1">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <a href="" class="a1">消息通知&nbsp;&nbsp;</a>
            <span class="sp1">|&nbsp;&nbsp;</span>
            <a onclick="orderList()" class="a1">我的订单</a>
            <button class="bu2" onclick="on2()">
                <span class="glyphicon glyphicon-shopping-cart" id="gou">购物车(0)</span>
            </button>
        </div>
    </div>
    <div class="d2 row">
        <div>
            <img class="img1" src="img/zhuye/zhuye2.png"/>
        </div>
        <div class="d2-1">
            <div class="d2-1-1">
                <a class="a3" href="">小米手机</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">&nbsp;红米</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">电视</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">笔记本</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">盒子</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">新品&nbsp;</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">路由器&nbsp;&nbsp;</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">&nbsp;智能硬件</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">&nbsp;服务</a>
            </div>
            <div class="d2-1-1">
                <a class="a3" href="">社区</a>
            </div>
        </div>
        <div class="d2-2">
            <div class="d2-2-1">
                <form>
                    <input class="in1" id="search" onkeyup="fsearch(this)" type="text" placeholder="小米8 小米MIX 2s">
                    <button class="bu4" type="submit">
                        <span class="glyphicon glyphicon-search"></span>
                    </button>
                    <div id="div1"></div>
                </form>
            </div>
        </div>
    </div>
    <div class="d3 row">
        <div class="d3-1 col-lg-4 col-md-4">
            <span id="span1" class="sp3"></span> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">小米8 透明探索版</a> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">小米8 SE</a>
        </div>
        <div class="d3-1 col-lg-5 col-md-5"></div>
        <div class="d3-1 col-lg-3 col-md-3">
            <a class="a4" href="">概述</a> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">图集</a> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">参数</a> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">F码通道</a> <span class="sp4">&nbsp;|&nbsp;</span>
            <a class="a4" href="">用户评价</a>
        </div>
    </div>
    <div class="row d4">
        <div class="d4-1 col-lg-6 col-md-6">
            <!-- 轮播 -->
            <div id="myCarousel" class="carousel slide d4-1-1">
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="item active">
                        <a href=""><img class="img3"
                                        src="" alt="First slide"></a>
                    </div>
                    <div class="item">
                        <a href=""><img class="img3"
                                        src="" alt="Second slide"></a>
                    </div>
                    <div class="item">
                        <a href=""><img class="img3"
                                        src="" alt="Third slide"></a>
                    </div>
                </div>
                <a class="left carousel-control" href="#myCarousel" role="button"
                   data-slide="prev"> <span
                        class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a> <a class="right carousel-control" href="#myCarousel" role="button"
                        data-slide="next"> <span
                    class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
            </div>
        </div>
        <div class="col-lg-6 col-md-6 d4-2">
            <div class="d4-2-1">
                <h3 id="cname"></h3>
                <span class="sp5">「商城特惠」</span> <span id="span2" class="sp6"></span> <br/> <span
                    class="sp77" id="sp7"></span>
            </div>
            <div class="d4-2-2">
                &nbsp; <span class="glyphicon glyphicon-map-marker"> 天津
						&nbsp;天津市 &nbsp;东丽区 &nbsp;保税区空港国际物流经济区&nbsp; </span> <a class="a5"
                                                                                href="">修改</a> <br/> <a class="a7"
                                                                                                        id="a7" href="">有现货</a><span
                    id="kc"></span>
            </div>
            <h4 class="hh2">选择版本</h4>

            <div id="div2" class="d4-2-3">
                <c:forEach items="${banben}" var="b">
                    <button class="d4-2-3-1" onclick="banben1(this)" value="${b[0]}">
                        <span class="sp7">&nbsp;&nbsp;${b[0]}</span>
                    </button>
                </c:forEach>

            </div>
            <h4 class="hh2">选择颜色</h4>
            <div class="d4-2-4" id="d4-2-4"></div>
            <div class="d4-2-5 row">
                <button class="d4-2-5-1 col-lg-6 col-md-6" id="gwc"
                        onclick="cart(this)" value="" onclick="on2()">
                    <span class="sp9" id="sp9">加入购物车</span>
                </button>
                <button class="d4-2-5-2 col-lg3 col-md-3">
						<span class="sp9"><span
                                class="glyphicon glyphicon-heart-empty sp10"></span> 喜欢</span>
                </button>
            </div>
        </div>
    </div>
    <div class="d5 row">
        <h3>特别说明</h3>
        <img src="img/xiangqing/xiangqing2-1.png"/>
    </div>
    <hr/>
    <%@include file="bottom.jsp" %>
</div>
</body>


</html>