package com.mhf.controller.backend;

import com.mhf.common.ServerResponse;
import com.mhf.service.IOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/manager1/order")
public class OrderManagerController {

    @Autowired
    IOrderService iOrderService;

    /**
     * 订单列表
     */
    @RequestMapping(value = "list")
    public ServerResponse list(@RequestParam(required = false, defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false, defaultValue = "10") Integer pageSize) {

        ServerResponse serverResponse = iOrderService.list(null, pageNum, pageSize);
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
     * 订单发货
     */
    @RequestMapping(value = "sendGoods/{orderNo}")
    public ServerResponse sendGoods(@PathVariable("orderNo") Long orderNo) {

        ServerResponse serverResponse = iOrderService.sendGoods(orderNo);
        return serverResponse;
    }
}
