package com.mhf.controller.portal;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import com.mhf.utils.MD5Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/user")
public class UserController {

    @Autowired
    IUserService iUserService;

    /**
     * 登录
     */
    @RequestMapping(value = "/login.do")
    public ServerResponse login(HttpSession session, @RequestParam("username")String username, @RequestParam("password")String password){
        ServerResponse serverResponse = iUserService.login(username,password);
        if(serverResponse.isSuccess()){
            User user = (User) serverResponse.getData();
            session.setAttribute(Const.CURRENTUSER,user);
        }
        return serverResponse;
    }

    /**
     * 注册
     */
    @RequestMapping(value = "/register.do")
    public ServerResponse register(HttpSession session,User user){
        ServerResponse serverResponse = iUserService.register(user);
        return serverResponse;
    }

    /**
     * 根据用户名找回密保问题
     */
    @RequestMapping(value = "getQuestion.do")
    public ServerResponse getQuestion(String username){
        ServerResponse serverResponse = iUserService.getQuestion(username);
        return serverResponse;
    }

    /**
     * 提交密保问题答案，并验证
     */
    @RequestMapping(value = "checkAnswer.do")
    public ServerResponse checkAnswer(String username,String question,String answer){
        ServerResponse serverResponse = iUserService.checkAnswer(username,question,answer);
        return serverResponse;
    }
    /**
     * 重置密码
     */
    @RequestMapping(value = "resetPassword.do")
    public ServerResponse resetPassword(String username,String password,String forgetToken){
        ServerResponse serverResponse = iUserService.resetPassword(username,password,forgetToken);
        return serverResponse;
    }
}
