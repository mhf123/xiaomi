package com.mhf.service;

import com.mhf.common.ServerResponse;
import com.mhf.pojo.Shipping;

public interface IAddressService {

    /**
     * 添加收货地址接口
     */
    ServerResponse add(Integer userId, Shipping shipping);

    /**
     * 删除收货地址接口
     */
    ServerResponse delete(Integer userId, Integer shippingId);

    /**
     * 更新收货地址接口
     */
    ServerResponse update(Shipping shipping);

    /**
     * 查看具体地址接口
     */
    ServerResponse select(Integer shippingId);

    /**
     * 分页查询地址列表
     */
    ServerResponse list(Integer pageNum, Integer pageSize);
}
