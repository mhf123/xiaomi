package com.mhf.controller.portal;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.Shipping;
import com.mhf.pojo.User;
import com.mhf.service.IAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/address")
public class AddressController {
    @Autowired
    IAddressService iAddressService;
    /**
     * 新增地址
     */
    @RequestMapping(value = "add")
    public ServerResponse add(HttpSession session, Shipping shipping) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iAddressService.add(user.getId(), shipping);
        return serverResponse;
    }

    /**
     * 删除地址
     */
    @RequestMapping(value = "delete/{shippingId}")
    public ServerResponse delete(HttpSession session,@PathVariable("shippingId") Integer shippingId) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iAddressService.delete(user.getId(), shippingId);
        return serverResponse;
    }
    /**
     * 更新地址
     */
    @RequestMapping(value = "update")
    public ServerResponse update(HttpSession session, Shipping shipping) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        shipping.setUserId(user.getId());
        ServerResponse serverResponse = iAddressService.update(shipping);
        return serverResponse;
    }

    /**
     * 查看具体地址
     */
    @RequestMapping(value = "select/{shippingId}")
    public ServerResponse select(@PathVariable("shippingId") Integer shippingId) {

        ServerResponse serverResponse = iAddressService.select(shippingId);
        return serverResponse;
    }

    /**
     * 查看地址列表
     */
    @RequestMapping(value = "list")
    public ServerResponse list(@RequestParam(required = false,defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false,defaultValue = "10")Integer pageSize) {

        ServerResponse serverResponse = iAddressService.list(pageNum,pageSize);
        return serverResponse;
    }

}
