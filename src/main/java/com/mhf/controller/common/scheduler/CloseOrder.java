package com.mhf.controller.common.scheduler;

import com.mhf.service.IOrderService;
import com.mhf.utils.PropertiesUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class CloseOrder {

    @Autowired
    IOrderService iOrderService;

    /**
     * 定时关闭订单
     */

    @Scheduled(cron = "0 */1 * * * ?")
    public void closeOrder(){
        Integer hour =Integer.parseInt( PropertiesUtils.readByKey("close.order.time"));
        String date = com.mhf.utils.DateUtils.dateToStr(DateUtils.addHours(new Date(),-hour));
        iOrderService.orderClose(date);
    }
}
