package com.mhf.controller.backend;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.ICategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/manager1/category")
public class CategoryManageController {

    @Autowired
    ICategoryService iCategoryService;

    /**
     * 获取品类子节点（平级）
     */
    @RequestMapping(value = "/getCategory.do")
    public ServerResponse getCategory(HttpSession session,Integer id){
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if(user == null){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(),Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
        }
        //判断是否是管理员
        if(user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(),Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        //获取子节点
        ServerResponse category = iCategoryService.getCategory(id);
        return category;
    }

    /**
     * 增加节点
     */
    @RequestMapping(value = "/addCategory.do")
    public ServerResponse addCategory(HttpSession session,@RequestParam(required = false,defaultValue = "0") Integer parentId,String categoryName){
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if(user == null){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(),Const.ResponseCodeEnum.NEED_LOGIN.getDesc());

        }
        //判断是否是管理员
        if(user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(),Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        //获取子节点
        ServerResponse category = iCategoryService.addCategory(parentId,categoryName);
        return category;
    }

    /**
     * 修改类别名字
     */
    @RequestMapping(value = "/setCategoryName.do")
    public ServerResponse setCategoryName(HttpSession session,Integer categoryId,String categoryName){
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if(user == null){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(),Const.ResponseCodeEnum.NEED_LOGIN.getDesc());

        }
        //判断是否是管理员
        if(user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(),Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        //获取子节点
        ServerResponse category = iCategoryService.setCategoryName(categoryId,categoryName);
        return category;
    }

    /**
     * 获取当前分类id以及递归子节点
     */
    @RequestMapping(value = "/getDeepCategory.do")
    public ServerResponse getDeepCategory(HttpSession session,Integer categoryId){
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //判断是否登录
        if(user == null){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(),Const.ResponseCodeEnum.NEED_LOGIN.getDesc());

        }
        //判断是否是管理员
        if(user.getRole() != Const.RoleEnum.ROLE_ADMIN.getCode()){
            return ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(),Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
        }
        //获取子节点
        ServerResponse category = iCategoryService.getDeepCategory(categoryId);
        return category;
    }
}
