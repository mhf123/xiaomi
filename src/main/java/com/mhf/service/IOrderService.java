package com.mhf.service;

import com.mhf.common.ServerResponse;
import org.omg.PortableInterceptor.INACTIVE;

import java.util.Map;

public interface IOrderService {
    /**
     * 创建订单接口
     */
    ServerResponse createOrder(Integer userId,Integer shippingId);

    /**
     * 获取购物车中订单的商品明细接口
     */
    ServerResponse getOrderCartProduct(Integer userId);

    /**
     * 取消订单接口
     */
    ServerResponse cancel(Integer userId, Long orderNo);

    /**
     * 订单列表接口
     */
    ServerResponse list(Integer userId,Integer pageNum,Integer pageSize);

    /**
     * 订单详情接口
     */
    ServerResponse detail(Long orderNo);

    /**
     * 订单发货接口
     */
    ServerResponse sendGoods(Long orderNo);

    /**
     * 支付接口
     */
    ServerResponse pay(Long orderNo);

    /**
     * 查询订单支付状态接口
     */
    ServerResponse queryOrderPayStatus(Long orderNo);

    /**
     * 支付宝回调接口
     */
    ServerResponse alipayCallback(Map<String,String> map);
}
