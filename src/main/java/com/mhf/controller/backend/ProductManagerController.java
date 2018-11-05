package com.mhf.controller.backend;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.Product;
import com.mhf.pojo.User;
import com.mhf.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/manager1/product")
public class ProductManagerController {

    @Autowired
    IProductService iProductService;

    /**
     * 新增OR更新商品
     */
    @RequestMapping(value = "/saveOrUpdate.do")
    public ServerResponse saveOrUpdate(HttpSession session, Product product) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.saveOrUpdate(product);
        return serverResponse;
    }

    /**
     * 产品上下架
     */
    @RequestMapping(value = "/setSaleStatus.do")
    public ServerResponse setSaleStatus(HttpSession session, Integer productId, Integer status) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.setSaleStatus(productId, status);
        return serverResponse;
    }

    /**
     * 商品详情
     */
    @RequestMapping(value = "/detail.do")
    public ServerResponse detail(HttpSession session, Integer productId) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.detail(productId);
        return serverResponse;
    }

    /**
     * 查询商品列表
     */
    @RequestMapping(value = "/list.do")
    public ServerResponse detail(HttpSession session,
                                 @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize",required = false, defaultValue = "10") Integer pageSize) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.list(pageNum,pageSize);
        return serverResponse;
    }

    /**
     * 产品搜索
     */
    @RequestMapping(value = "/search.do")
    public ServerResponse search(HttpSession session,
                                 @RequestParam(value = "productId",required = false) Integer productId,
                                 @RequestParam(value = "productName",required = false) String productName,
                                 @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize",required = false, defaultValue = "10") Integer pageSize) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.search(productId,productName,pageNum,pageSize);
        return serverResponse;
    }

    /**
     * 图片上传
     */
    @RequestMapping(value = "/upload.do")
    public ServerResponse upload(HttpSession session,
                                 @RequestParam(value = "productId",required = false) Integer productId,
                                 @RequestParam(value = "productName",required = false) String productName,
                                 @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize",required = false, defaultValue = "10") Integer pageSize) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if (user == null) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if (user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()) {
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        ServerResponse serverResponse = iProductService.search(productId,productName,pageNum,pageSize);
        return serverResponse;
    }
}
