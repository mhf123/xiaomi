package com.mhf.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Maps;
import com.mhf.common.ServerResponse;
import com.mhf.dao.ShippingMapper;
import com.mhf.pojo.Shipping;
import com.mhf.service.IAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class AddressServiceImpl implements IAddressService {
    @Autowired
    ShippingMapper shippingMapper;

    @Transactional
    @Override
    public ServerResponse add(Integer userId, Shipping shipping) {
        // 1、参数校验
        if (shipping == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、添加
        shipping.setUserId(userId);
        shippingMapper.insert(shipping);
        // 3、返回结果
        Map<String, Integer> map = Maps.newHashMap();
        map.put("shippingId", shipping.getId());
        return ServerResponse.serverResponseBySuccess(map);
    }

    @Transactional
    @Override
    public ServerResponse delete(Integer userId, Integer shippingId) {
        // 1、参数校验
        if (shippingId == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、删除
        int result = shippingMapper.deleteByUserIdAndShippingId(userId, shippingId);
        // 3、返回结果
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        }
        return ServerResponse.serverResponseByError("删除失败");
    }

    @Transactional
    @Override
    public ServerResponse update(Shipping shipping) {
        // 1、参数校验
        if (shipping == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、更新
        int result = shippingMapper.updateBySelectiveKey(shipping);

        // 3、返回结果
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        }
        return ServerResponse.serverResponseByError("更新失败");
    }

    @Override
    public ServerResponse select(Integer shippingId) {
        // 1、参数校验
        if (shippingId == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、查询
        Shipping shipping = shippingMapper.selectByPrimaryKey(shippingId);
        // 3、返回结果
        return ServerResponse.serverResponseBySuccess(shipping);
    }

    @Override
    public ServerResponse list(Integer pageNum, Integer pageSize) {
        //分页查询
        PageHelper.startPage(pageNum, pageSize);
        List<Shipping> shippingList = shippingMapper.selectAll();
        PageInfo pageInfo = new PageInfo(shippingList);

        return ServerResponse.serverResponseBySuccess(pageInfo);
    }
}
