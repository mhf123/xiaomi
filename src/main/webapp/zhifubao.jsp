<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>

<head>
    <meta charset="UTF-8"/>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script src="js/jquery-3.3.1.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="css/zfb.css"/>
    <title>支付宝当面付</title>

    <script>
        /**
         * 加载页面数据
         */
        $(document).ready(function () {
            //获取订单号
            var orderNo = getUrlParam("orderNo");
            //持续监测订单状态
            window.setInterval(function (){
                orderStatus(orderNo);
            }, 1000);

            //订单信息
            $.ajax({
                type: "post",
                url: "/order/detail/" + orderNo,
                success: function (data) {
                    if (data.status == 0) {
                        //创建订单时间
                        var time = data.data.createTime;
                        //计时器，60分钟后关闭订单
                        window.setInterval(function (){
                            refreshCount(time);
                        }, 100);
                        $("#div1").text(data.data.payment);
                        $("#strong1").text(data.data.payment);
                    } else {
                        alert("获取订单信息失败！" + data.msg);
                    }
                },
                dataType: "JSON"
            })
            //当面付二维码
            $.ajax({
                type: "post",
                url: "/order/pay/" + orderNo,
                success: function (data) {
                    if (data.status == 0) {
                        $("#span1").text("订单号：" + orderNo);
                        var str = "<img style='width: 100%;height: 100%;' src ='" + data.data.qrCode + "'/>";
                        $("#div2").html(str);
                    } else {
                        alert("支付宝获取二维码失败！" + data.msg);
                    }
                },
                dataType: "JSON"
            })
        })

        //持续监测订单状态
        function orderStatus(orderNo){
            //订单信息
            $.ajax({
                type: "post",
                url: "/order/detail/" + orderNo,
                success: function (data) {
                    if (data.status == 0) {
                       if (data.data.status == 0){
                           $("#error").show();
                       }else if (data.data.status == 20) {
                           $("#success").show();
                           window.setTimeout(function () {
                               location.href = "orderList.jsp";
                           },3000)
                       }else if (data.data.status == 10){
                            //正常状态
                       } else {
                           alert("订单状态不适合付款！");
                           location.href = "zhuye.jsp";
                       }
                    } else {
                        alert("获取订单信息失败！" + data.msg);
                    }
                },
                dataType: "JSON"
            })
        }

        //订单60分钟后取消（计时显示）
        function refreshCount(time) {
            var date = new Date(time);
            var date1 = new Date();
            var time1 = date.getTime();
            var time2 = date1.getTime();
            var time3 = 60 - Math.round((time2 - time1) / (1000 * 60));
            if (time3 <= 0) {
                $("#teOrderDelayText").text(0 + "分钟");
                return;
            }
            $("#teOrderDelayText").text(time3 + "分钟");

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

    </script>
</head>

<body>
<div class="topbar">
    <div class="topbar-wrap fn-clear">
        <a href="https://help.alipay.com/lab/help_detail.htm?help_id=258086" class="topbar-link-last" target="_blank"
           seed="goToHelp">常见问题</a>
        <span class="topbar-link-first">你好，欢迎使用支付宝付款！</span>
    </div>
</div>

<div id="header">
    <div class="header-container fn-clear">
        <div class="header-title">
            <div class="alipay-logo"></div>
            <span class="logo-title">我的收银台</span>
        </div>
    </div>
</div>

<div id="container">
    <div class="mi-notice mi-notice-success mi-notice-titleonly" id="success" hidden>
        <div class="mi-notice-cnt">
            <div class="mi-notice-title">
                <i class="iconfont" title="支付成功">&#xF049;</i>
                <h3>支付成功，<span class="ft-orange">3</span> 秒后自动返回。</h3>
            </div>
        </div>
    </div>

    <div class="mi-notice mi-notice-error mi-notice-titleonly" id="error" hidden>
        <div class="mi-notice-cnt">
            <div class="mi-notice-title">
                <i class="iconfont" title="交易超时">&#xF045;</i>
                <h3>您的此次交易因超时已失败。</h3>
                <p class="mi-notice-explain-other">
                    您订单目前已过期，交易关闭。
                </p>
            </div>
        </div>
    </div>

    <!-- 页面主体 -->
    <div id="content" class="fn-clear">
        <div id="J_order" class="order-area" data-module="excashier/login/2015.08.01/orderDetail">
            <div id="order" data-role="order" class="order order-bow">
                <div class="orderDetail-base" data-role="J_orderDetailBase">
                    <div class="order-extand-explain fn-clear">
								<span class="fn-left explain-trigger-area order-type-navigator" style="cursor: auto"
                                      data-role="J_orderTypeQuestion">
            						<span>正在使用即时到账交易，</span>
								</span>
                                <span class="fn-left create-time" id="teDelay">
                					<span>交易将在<span style="color: #FF6700;" id="teOrderDelayText">60分钟</span>后关闭，请及时付款！</span>
								</span>
                    </div>
                    <div class="commodity-message-row">
								<span class="first long-content" id="span1">
            					</span>
                        <span class="second short-content">
                                   	收款方：小米商城
                            	</span>
                    </div>
                    <span class="payAmount-area" id="J_basePriceArea">
                                <strong class="amount-font-22" id="strong1"></strong> 元
        					</span>
                </div>
            </div>
        </div>
    </div>

    <div class="cashier-center-container">
        <!-- 扫码支付页面 -->
        <div class="cashier-center-view view-qrcode fn-left" id="J_view_qr">
            <div data-role="qrPayArea" class="qrcode-integration qrcode-area" id="J_qrPayArea">
                <div class="qrcode-header">
                    <div class="ft-center">扫一扫付款（元）</div>
                    <div class="ft-center qrcode-header-money" id="div1"></div>
                </div>

                <div class="qrcode-img-wrapper" data-role="qrPayImgWrapper">
                    <div data-role="qrPayImg" class="qrcode-img-area" id="div2">
                        <div class="ui-loading qrcode-loading" data-role="qrPayImgLoading">加载中</div>
                    </div>

                    <div class="qrcode-img-explain fn-clear">
                        <img class="fn-left" src="https://t.alipayobjects.com/images/T1bdtfXfdiXXXXXXXX.png"
                             alt="扫一扫标识">
                        <div class="fn-left">打开手机支付宝<br>扫一扫继续付款</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>

</html>