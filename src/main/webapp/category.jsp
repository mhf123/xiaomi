<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>米迦商城-商品列表</title>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css"/>
    <script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="css/category.css"/>
    <script type="text/javascript">
        //搜索内容
        var searchContent = "";
        //分类id
        var categoryId = undefined;

        $(document).ready(function () {
            //修改购物车按钮中购物车数量颜色
            $("#d").hover(function () {
                $("#num").css({
                    "background-color": "#FF6700"
                });
            }, function () {
                $("#num").css({
                    "background-color": "#777777"
                });
            });
            //获取购物车商品数量
            $.ajax({
                type: "post",
                url: "/cart/getCartProductCount",
                success: function (data) {
                    if (data.status == 0) {
                        $("#num").text(data.data);
                    }
                },
                dataType: "JSON"
            })
            //获取搜索内容
            searchContent = getUrlParam("searchContent");
            //搜索
            $("#search").val(searchContent);
            $.ajax({
                type: "post",
                url: "/product/list",
                data: {
                    "keyword": searchContent
                },
                success: function (data) {
                    categoryList(data);
                    productList(data);
                },
            })

        })

        /**
         * 初始化和修改点击分类、品牌和排序方式的颜色
         */
        function initialize() {
            $(".bu5:nth-of-type(1)").css({
                "color": "#FF6700"
            });
            $(".bu5-1:nth-of-type(1)").css({
                "color": "#FF6700"
            });
            $(".bu6:nth-of-type(1)").css({
                "color": "#FF6700"
            });
            $(".bu5").click(function () {
                $(".bu5").css({
                    "color": "black"
                });
                $(this).css({
                    "color": "#FF6700"
                });
            })
            $(".bu5-1").click(function () {
                $(".bu5-1").css({
                    "color": "black"
                });
                $(this).css({
                    "color": "#FF6700"
                });
            })
            $(".bu6").click(function () {
                $(".bu6").css({
                    "color": "black"
                });
                $(this).css({
                    "color": "#FF6700"
                });
            })

            //点击不同分类、排序规则等
            $(".bu6").click(function () {
                var value = $(this).val();
                if (value == "推荐"){
                    search(searchContent,categoryId);
                }else if(value == "新品"){
                    search(searchContent,categoryId,"create_time_desc");
                }else if(value == "价格↑"){
                    search(searchContent,categoryId,"price_asc");
                }else if(value == "价格↓"){
                    search(searchContent,categoryId,"price_desc");
                }
            })

            $(".bu5").click(function () {
                //初始化排序规则
                $(".bu6").css({
                    "color": "black"
                });
                $(".bu6:nth-of-type(1)").css({
                    "color": "#FF6700"
                });
                categoryId = $(this).val();
                if (categoryId == ""){
                    search(searchContent);
                }else{
                    search(searchContent,categoryId);
                }
            })
        }

        /**
         * 搜索
         */
        function search(searchContent, categoryId, orderBy) {
            if (categoryId == undefined || categoryId == "") {
                if (orderBy == undefined || orderBy == "") {
                    $.ajax({
                        type: "post",
                        url: "/product/list",
                        data: {
                            "keyword": searchContent
                        },
                        success: function (data) {
                            productList(data);
                        },
                    })
                } else {
                    $.ajax({
                        type: "post",
                        url: "/product/list",
                        data: {
                            "keyword": searchContent,
                            "orderBy": orderBy,
                        },
                        success: function (data) {
                            productList(data);
                        },
                    })
                }
            } else if (orderBy == undefined || orderBy == "") {
                $.ajax({
                    type: "post",
                    url: "/product/list",
                    data: {
                        "keyword": searchContent,
                        "categoryId": categoryId,
                    },
                    success: function (data) {
                        productList(data);
                    },
                })
            } else {
                $.ajax({
                    type: "post",
                    url: "/product/list",
                    data: {
                        "keyword": searchContent,
                        "categoryId": categoryId,
                        "orderBy": orderBy,
                    },
                    success: function (data) {
                        productList(data);
                    },
                })
            }

        }

        /**
         * 显示分类列表
         */
        function categoryList(data) {
            //显示分类列表
            var str = "";
            var str1 = "";
            for (var i = 0; i < data.data.list[1].length; i++) {
                str1 += "<button class='bu5' value='" + data.data.list[1][i].id + "'>" +
                    data.data.list[1][i].name +
                    "</button>";
            }
            str += "<p class='p3'>分类：</p>" +
                "<button class='bu5'>" +
                "    全部" +
                "</button>" +
                str1 +
                "</div>"
            $("#category").html(str);
            //初始化和修改点击分类、品牌和排序方式的颜色
            initialize();
        }

        /**
         * 显示搜索结果商品列表
         */
        function productList(data) {
            if (data.status == 0) {
                if (data.data.list[0].length > 0){
                    //显示商品列表
                    str = "";
                    for (var i = 0; i < data.data.list[0].length; i++) {
                        str += " <button class='bu7' value='" + data.data.list[0][i].name + "' onclick='xiangqing(this)'>" +
                            "        <img class='img3' src='" + data.data.list[0][i].mainImage + "'/>" +
                            "        <p class='p5'>" + data.data.list[0][i].name + "</p>" +
                            "        <p class='p4'>" + data.data.list[0][i].price + " 元" + "</p>" +
                            "    </button>";
                    }
                    $("#list").html(str);
                }else {
                    var str = "<p class='p6'>没有搜索到与“<span class='sp2'>"+ searchContent +"</span>”有关的商品</p>";
                    str += "<p class='p7'>请检查您的输入是否有误</p>"
                    str += "<a href='zhuye.jsp' class='sp2'>返回</a>"
                    $("#div4").html(str);
                    $(".d4").hide();
                    $(".d5").hide();
                    $(".d6").hide();
                }
            } else {
                alert("搜索失败！" + data.msg);
            }
        }

        /**
         * 点击商品进入商品详情界面
         */
        function xiangqing(th) {
            var productName = $(th).val();
            location.href = "/xiangqing.jsp?name=" + encodeURI(productName);
        }

        /**
         * 点击搜索按钮
         */
        function search1(th) {
            var searchContent = $(th).prev().val();
            if (searchContent != "") {
                location.href = "category.jsp?searchContent=" + encodeURI(searchContent);
            }
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

        //点击购物车
        function on2() {
            if ("${current_user}" == "") {
                var t = confirm("你还未登录，是否前往登录？")
                if (t == true) {
                    window.location.href = "denglu1.jsp";
                }
            } else
                window.location.href = "gouwuche.jsp";
        }

        /**
         * 搜索提示功能
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
                //获取搜索提示的数据并输出
                success: function (data) {
                    if (data.status == 0) {
                        if (data.data.list.length > 0)
                            $("#div1").css("border", "1px solid #A6A6A6");
                        for (var i = 0; i < data.data.list.length; i++)
                            str += "<div style='line-height:30px' onmousemove='xiala1(this)' onclick='xiala2(this)' onmouseout='xiala3(this)'>" +
                                data.data.list[i].name + "</div>";
                        $("#div1").html(str);
                    }
                },
                dataType: "JSON"
            })

        }

        /**
         * 点击我的订单
         */
        function orderList() {
            if ("${current_user}" == "") {
                location.href = "denglu1.jsp";
            } else {
                location.href = "orderList.jsp";
            }
        }

        /**
         * 如果未登录，则转到登录界面
         */
        function on1() {
            if ("${current_user}" == "") {
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
                        alert("退出登录失败！")
                    }
                },
                dataType: "JSON"
            })
        }
    </script>
</head>

<body onclick="close_xiala()">
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
        <div id="div3">
            <!--下拉式菜单-->
            <div class="d1-2 dropdown">
                <button class="bu1" onclick="on1()" id="dLabel" type="button" data-toggle="dropdown"
                        aria-haspopup="true" aria-expanded="false">
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
            <span class="sp1">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <a href="" class="a1">消息通知&nbsp;&nbsp;</a>
            <span class="sp1">|&nbsp;&nbsp;</span>
            <a onclick="orderList()" class="a1">我的订单</a>
            <button class="bu2" id="d" onclick="on2()">
                <span class="glyphicon glyphicon-shopping-cart">购物车</span>
                <span class="badge" id="num">0</span>
            </button>
        </div>
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
                <input class="in1" id="search" type="text" onkeyup="fsearch(this)" placeholder="小米8 小米MIX 2s">
                <button class="bu4" type="submit" onclick="search1(this)">
                    <span class="glyphicon glyphicon-search"></span>
                </button>
                <div id="div1"></div>
            </div>
        </div>
    </div>
    <div class="d3" id="div4">
        <div class="d3-1" id="category">
        </div>
        <hr class="hr1"/>
        <div class="d3-1">
            <p class="p3">品牌：</p>
            <button class="bu5-1">
                全部
            </button>
            <button class="bu5-1">
                小米
            </button>
        </div>

    </div>
    <div class="d5">
        <button class="bu6" value="推荐">
            推荐
        </button>
        <div class="d5-1"></div>
        <button class="bu6" value="新品">
            新品
        </button>
        <div class="d5-1"></div>
        <button class="bu6" value="价格↑">
            价格&nbsp;↑
        </button>
        <div class="d5-1"></div>
        <button class="bu6" value="价格↓">
            价格&nbsp;↓
        </button>
    </div>
    <div class="d6" id="list">
    </div>
    <div class="d4">
        <button class="bu8">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </button>
        <div id="pageNumber">
            <button class="bu8" style="color: #FF6700;">
                1
            </button>
        </div>
        <button class="bu8">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </button>
    </div>
</div>
<%@include file="bottom.jsp"%>
</body>

</html>