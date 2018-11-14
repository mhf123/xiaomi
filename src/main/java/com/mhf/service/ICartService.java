package com.mhf.service;

import com.mhf.common.ServerResponse;

public interface ICartService {

    /**
     * 购物车添加商品接口
     */
    ServerResponse add(Integer userId,Integer productId, Integer count);

    /**
     * 购物车列表接口
     */
    ServerResponse list(Integer userId);

    /**
     * 更新某个商品数量接口
     */
    ServerResponse update(Integer userId, Integer productId, Integer count);

    /**
     * 移除购物车某个商品接口
     */
    ServerResponse deleteProduct(Integer userId, String productIds);

    /**
     * 购物车选中某个商品接口
     */
    ServerResponse select(Integer userId, Integer productId,Integer check);

    /**
     * 购物车商品数量
     * @param userId
     * @return
     */
    ServerResponse getCartProductCount(Integer userId);
}
