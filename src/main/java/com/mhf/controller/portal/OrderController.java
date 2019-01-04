package com.mhf.controller.portal;

import com.alipay.api.AlipayApiException;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.demo.trade.config.Configs;
import com.google.common.collect.Maps;
import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.http.HttpRequest;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Iterator;
import java.util.Map;

@RestController
@RequestMapping(value = "/order")
public class OrderController {
    @Autowired
    IOrderService iOrderService;

    /**
     * 创建订单
     */
    @RequestMapping(value = "create/{shippingId}")
    public ServerResponse add(HttpSession session, @PathVariable("shippingId") Integer shippingId) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iOrderService.createOrder(user.getId(), shippingId);
        return serverResponse;
    }

    /**
     * 获取订单的商品信息
     */
    @RequestMapping(value = "getOrderCartProduct")
    public ServerResponse getOrderCartProduct(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iOrderService.getOrderCartProduct(user.getId());
        return serverResponse;
    }

    /**
     * 取消订单
     */
    @RequestMapping(value = "cancel/{orderNo}")
    public ServerResponse cancel(HttpSession session, @PathVariable("orderNo") Long orderNo) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iOrderService.cancel(user.getId(), orderNo);
        return serverResponse;
    }

    /**
     * 按状态查询订单列表
     */
    @RequestMapping(value = "list")
    public ServerResponse list(HttpSession session,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(required = false, defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false, defaultValue = "10") Integer pageSize) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iOrderService.list(user.getId(), pageNum, pageSize, status);
        return serverResponse;
    }

    /**
     * 订单详情
     */
    @RequestMapping(value = "detail/{orderNo}")
    public ServerResponse list(@PathVariable("orderNo") Long orderNo) {

        ServerResponse serverResponse = iOrderService.detail(orderNo);
        return serverResponse;
    }


    /**
     * 支付
     */
    @RequestMapping(value = "/pay/{orderNo}")
    public ServerResponse pay(@PathVariable("orderNo") Long orderNo) {

        ServerResponse serverResponse = iOrderService.pay(orderNo);
        return serverResponse;
    }

    /**
     * 查询订单支付状态
     */
    @RequestMapping(value = "/queryOrderPayStatus/{orderNo}")
    public ServerResponse queryOrderPayStatus(@PathVariable("orderNo") Long orderNo) {

        ServerResponse serverResponse = iOrderService.queryOrderPayStatus(orderNo);
        return serverResponse;
    }

    /**
     * 支付宝回调应用服务器
     */
    @RequestMapping(value = "alipayCallback.do")
    public ServerResponse alipayCallback(HttpServletRequest request) {
        Map<String, String[]> map = request.getParameterMap();
        Map<String, String> requestMap = Maps.newHashMap();
        Iterator<String> it = map.keySet().iterator();
        while (it.hasNext()) {
            String key = it.next();
            String[] strArr = map.get(key);
            String value = "";
            for (int i = 0; i < strArr.length; i++) {
                value = (i == strArr.length - 1) ? value + strArr[i] : value + strArr[i] + ",";
            }
            requestMap.put(key, value);
        }

        // 1、支付宝验证签名
        try {
            requestMap.remove("sign_type");
            boolean b = AlipaySignature.rsaCheckV2(requestMap, Configs.getAlipayPublicKey(), "UTF-8", Configs.getSignType());
            if (!b) {
                return ServerResponse.serverResponseByError("非法请求，验证不通过");
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        // 处理业务逻辑
        ServerResponse serverResponse = iOrderService.alipayCallback(requestMap);

        return serverResponse;
    }

    /**
     * 确认收货
     */
    @RequestMapping(value = "/confirm/{orderNo}")
    public ServerResponse confirm(HttpSession session, @PathVariable("orderNo") Long orderNo) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        ServerResponse serverResponse = iOrderService.confirm(user.getId(),orderNo);
        return serverResponse;
    }

}
