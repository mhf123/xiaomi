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
    <link rel="stylesheet" type="text/css" href="css/zhuye.css"/>

    <script type="text/javascript">
        /**
         * 网页加载完成后，显示用户购物车商品数量
         */
        $(document).ready(function () {
            //获取购物车商品数量
            var n = "${count}"
            //如果已登录，则显示数量
            if ($("#dl").text() != "你好，请登录")
                $("#num").text(n);
        })

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
            $
                .ajax({
                    type: "post",
                    url: "/xiaomi/CommodityServlet",
                    //把输入的数据穿到后台
                    data: {
                        "val": val
                    },
                    //获取搜索提示的数据并输出
                    success: function (data) {
                        if (data.length > 0)
                            $("#div1").css("border", "1px solid #A6A6A6");
                        for (var i = 0; i < data.length; i++)
                            str += "<div onmousemove='xiala1(this)' onclick='xiala2(this)' onmouseout='xiala3(this)'>"
                                + data[i].cname + "</div>";
                        $("#div1").html(str);
                    },
                    dataType: "JSON"
                })

        }

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

        /**
         * 显示各分类的商品
         */

        //鼠标悬停在分类上，显示此类型商品
        function onm(th) {
            //获取分类名称
            var val = $(th).val();
            $
                .ajax({
                    type: "post",
                    url: "/xiaomi/ClassServlet",
                    //把分类名数据穿到后台
                    data: {
                        "val": val
                    },
                    //获取各分类商品数据和对应略缩图并显示在页面
                    success: function (data) {
                        $("#div2").show();
                        var str = "";
                        for (var i = 0; i < data.length; i++)
                            str += "<button class='fenlei' onclick='xiangqing(this)'><img src='" + data[i].cimg + "'>"
                                + data[i].cname + "</button>";
                        $("#div2").html(str);
                    },
                    dataType: "JSON"
                })
        }

        //鼠标移开，关闭分类商品显示
        function leave(th) {
            $(th).hide();
        }

        //鼠标移出网页，关闭分类商品显示
        function close_fenlei() {
            $("#div2").hide();
        }

        /**
         * 跳转商品详情
         */
        function xiangqing(th) {
            var hr = "DetailsServlet?cname=" + $(th).text()
            window.location.href = hr;
        }

        /**
         * 点击购物车，如果未登录，则用户确认后转到登录界面
         */

        function on2() {
            if ($("#dl").text() == "你好，请登录") {
                var t = confirm("你还未登录，是否前往登录？")
                if (t == true) {
                    window.location.href = "denglu1.jsp";
                }
            }
            else
                window.location.href = "CartServlet";
        }
    </script>
</head>

<body onclick="close_xiala()" onmouseleave="close_fenlei()">
<div class="container-fluid">
    <!--1-->
    <div class="row">
        <img class="img2" src="img/zhuye/zhuye1.png"/>
    </div>
    <!--2-->
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
        <!--下拉式菜单-->
        <div class="d1-2 dropdown">
            <button class="bu1" onclick="on1()" id="dLabel" type="button"
                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <c:if test="${iflogin == 1}">${sessionScope.name}</c:if>
                <c:if test="${empty iflogin}">
                    <span id="dl">你好，请登录</span>
                </c:if>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dLabel">
                <li><a class="a2" href="#">个人中心</a></li>
                <li><a class="a2" href="#">评价晒单</a></li>
                <li><a class="a2" href="#">我的喜欢</a></li>
                <li><a class="a2" href="#">小米账户</a></li>
                <li><a class="a2" href="LogOutServlet">退出登录</a></li>
            </ul>
        </div>
        <span class="sp1">&nbsp;&nbsp;|&nbsp;&nbsp;</span> <a href=""
                                                              class="a1">消息通知&nbsp;&nbsp;</a> <span class="sp1">|&nbsp;&nbsp;</span>
        <a href="" class="a1">我的订单</a>
        <button class="bu2" id="d" onclick="on2()">
            <span class="glyphicon glyphicon-shopping-cart">购物车 </span>
            <span class="badge" id="num">0</span>
        </button>
    </div>
    <!--3-->
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
                    <input class="in1" id="search" type="text" onkeyup="fsearch(this)"
                           onblur="onb1()" placeholder="小米8 小米MIX 2s">
                    <button class="bu4" type="submit">
                        <span class="glyphicon glyphicon-search"></span>
                    </button>
                    <div id="div1"></div>
                </form>
            </div>
        </div>
    </div>
    <div class="d3 row" onmouseleave="close_fenlei()">
        <div class="d3-1">
            <c:forEach items="${zclass}" var="cl">
                <button class="bu5" id="bum1" onmouseover="onm(this)" value="${cl[0]}">
                        ${cl[0]} <span class="sp2 glyphicon glyphicon-chevron-right"></span>
                </button>
            </c:forEach>

        </div>
        <div class="div3-2" id="div2" onmouseleave="leave(this)"></div>


        <div id="myCarousel" class="carousel slide d3-2">
            <!-- 轮播 -->
            <ol class="carousel-indicators">
                <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                <li data-target="#myCarousel" data-slide-to="1"></li>
                <li data-target="#myCarousel" data-slide-to="2"></li>
            </ol>
            <div class="carousel-inner">
                <div class="item active d3-2-1-1">
                    <a href=""><img class="img3" src="img/zhuye/zhuye2-1.png"
                                    alt="First slide"></a>
                </div>
                <div class="item d3-2-1-1">
                    <a href=""><img class="img3" src="img/zhuye/zhuye2-2.png"
                                    alt="Second slide"></a>
                </div>
                <div class="item d3-2-1-1">
                    <a href="xiangqing.html"><img class="img3"
                                                  src="img/zhuye/zhuye2-3.png" alt="Third slide"></a>
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

    <div class="d4 row">
        <div class="d4-1">
            <span class="sp3">小米闪购</span>
        </div>
        <div class="d4-2">
            <button class="bu6">
                <span class="glyphicon glyphicon-chevron-left"></span>
            </button>
            <button class="bu6">
                <span class="glyphicon glyphicon-chevron-right"></span>
            </button>
        </div>
    </div>
    <div class="d5 row">
        <div class="d5-1">
            <span class="sp4">20:00场</span> <br/> <br/> <img
                src="img/zhuye/zhuye4-1.png"/> <br/> <br/> <span class="sp5">距离结束还有</span>
            <br/> <br/>
            <div class="d5-1-1">
                <span class="sp6">00</span> <span class="sp7">:</span> <span
                    class="sp6">00</span> <span class="sp7">:</span> <span class="sp6">00</span>
            </div>
        </div>
        <div class="d5-6"></div>
        <div class="d5-2">
            <a href=""><img src="img/zhuye/zhuye4-2.png"/></a>
        </div>
        <div class="d5-6"></div>
        <div class="d5-3">
            <a href=""><img src="img/zhuye/zhuye4-3.png"/></a>
        </div>
        <div class="d5-6"></div>
        <div class="d5-4">
            <a href=""><img src="img/zhuye/zhuye4-4.png"/></a>
        </div>
        <div class="d5-6"></div>
        <div class="d5-5">
            <a href=""><img src="img/zhuye/zhuye4-5.png"/></a>
        </div>
    </div>
    <div class="d6">
        <a href=""><img src="img/zhuye/zhuye5.png"/></a>
    </div>
    <hr/>
    <%@include file="bottom.jsp" %>
    <div class="d9">
        <a class="a7 tooltip-test" data-toggle="tooltip"
           data-placement="left" title="个人中心" href=""><span
                class="glyphicon glyphicon-user"></span></a> <a class="a7 tooltip-test"
                                                                data-toggle="tooltip" data-placement="left" title="联系客服"
                                                                href=""><span
            class="glyphicon glyphicon-headphones"></span></a> <a
            class="a7 tooltip-test" data-toggle="tooltip" data-placement="left"
            title="购物车" href=""><span
            class="glyphicon glyphicon-shopping-cart"></span></a>
    </div>

</div>
</body>

</html>