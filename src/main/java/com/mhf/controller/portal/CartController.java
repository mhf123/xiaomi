package com.mhf.controller.portal;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.ICartService;
import com.mhf.vo.CartVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/cart")

public class CartController {
    @Autowired
    ICartService iCartService;

    /**
     * 购物车添加商品
     */
    @RequestMapping(value = "add/{productId}/{count}")
    public ServerResponse add(HttpSession session,
                              @PathVariable("productId") Integer productId,
                              @PathVariable("count") Integer count) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.add(user.getId(), productId, count);
        return serverResponse;
    }

    /**
     * 购物车列表
     */
    @RequestMapping(value = "list")
    public ServerResponse list(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.list(user.getId());
        return serverResponse;
    }

    /**
     * 更新购物车某个商品数量
     */
    @RequestMapping(value = "update/{productId}/{count}")
    public ServerResponse update(HttpSession session,
                                 @PathVariable("productId") Integer productId,
                                 @PathVariable("count") Integer count) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.update(user.getId(),productId,count);
        return serverResponse;
    }

    /**
     * 移除购物车某个商品
     */
    @RequestMapping(value = "deleteProduct/{productIds}")
    public ServerResponse deleteProduct(HttpSession session,@PathVariable("productIds")String productIds) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.deleteProduct(user.getId(),productIds);
        return serverResponse;
    }

    /**
     * 购物车选中某个商品
     */
    @RequestMapping(value = "select/{productId}")
    public ServerResponse select(HttpSession session,@PathVariable("productId")Integer productId) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.select(user.getId(),productId,Const.CartCheckedEnum.PRODUCT_CHECKED.getCode());
        return serverResponse;
    }

    /**
     * 购物车取消选中某个商品
     */
    @RequestMapping(value = "unselect/{productId}")
    public ServerResponse unselect(HttpSession session,@PathVariable("productId")Integer productId) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.select(user.getId(),productId,Const.CartCheckedEnum.PRODUCT_UNCHECKED.getCode());
        return serverResponse;
    }

    /**
     * 全选
     */
    @RequestMapping(value = "selectAll")
    public ServerResponse selectAll(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.select(user.getId(),null,Const.CartCheckedEnum.PRODUCT_CHECKED.getCode());
        return serverResponse;
    }

    /**
     * 全部取消选中
     */
    @RequestMapping(value = "unselectAll")
    public ServerResponse unselectAll(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.select(user.getId(),null,Const.CartCheckedEnum.PRODUCT_UNCHECKED.getCode());
        return serverResponse;
    }

    /**
     * 购物车商品数量
     */
    @RequestMapping(value = "getCartProductCount")
    public ServerResponse getCartProductCount(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        ServerResponse serverResponse = iCartService.getCartProductCount(user.getId());
        return serverResponse;
    }

}
