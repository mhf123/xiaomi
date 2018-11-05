package com.mhf.controller.backend;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

/**
 * 后台用户控制器类
 */
@RestController
@RequestMapping(value = "/manager1/user")
public class UserManagerController {

    @Autowired
    IUserService iUserService;

    /**
     * 管理员登录
     */
    @RequestMapping(value = "/login.do")
    public ServerResponse login(HttpSession session, @RequestParam("username")String username, @RequestParam("password")String password){
        ServerResponse serverResponse = iUserService.login(username,password);
        if(serverResponse.isSuccess()){
            User user = (User) serverResponse.getData();
            if(user.getRole() == Const.RoleEnum.ROLE_CUS.getCode()){
                return ServerResponse.serverResponseByError("没有登陆权限");
            }
            session.setAttribute(Const.CURRENTUSER,user);
        }
        return serverResponse;
    }

}
