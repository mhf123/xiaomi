package com.mhf.controller.portal;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
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

@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
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
     * 忘记密码重置密码
     */
    @RequestMapping(value = "resetPassword.do")
    public ServerResponse resetPassword(String username,String password,String forgetToken){
        ServerResponse serverResponse = iUserService.forgetResetPassword(username,password,forgetToken);
        return serverResponse;
    }

    /**
     * 检查用户名和邮箱是否有效
     */
    @RequestMapping(value = "checkValid.do")
    public ServerResponse checkValid(String str,String type){
        ServerResponse serverResponse = iUserService.checkValid(str,type);
        return serverResponse;
    }

    /**
     * 获取登录用户信息
     */
    @RequestMapping(value = "getUser.do")
    public ServerResponse getUser(HttpSession session){

        User user = (User)session.getAttribute(Const.CURRENTUSER);
        if(user == null){
            return ServerResponse.serverResponseByError("用户未登录");
        }
        User newuser = new User();
        newuser.setId(user.getId());
        newuser.setUsername(user.getUsername());
        newuser.setPhone(user.getPhone());
        newuser.setEmail(user.getEmail());
        return ServerResponse.serverResponseBySuccess(newuser);
    }

    /**
     * 登录状态下重置密码
     */
    @RequestMapping(value = "loginResetPassword.do")
    public ServerResponse loginResetPassword(HttpSession session,String oldPassword,String newPassword){
        User user = (User)session.getAttribute(Const.CURRENTUSER);
        if(user == null){
            return ServerResponse.serverResponseByError("用户未登录");
        }
        ServerResponse serverResponse = iUserService.loginResetPassword(user.getUsername(),oldPassword,newPassword);
        return serverResponse;
    }

    /**
     * 登录状态更新个人信息
     */
    @RequestMapping(value = "updateInformation.do")
    public ServerResponse updateInformation(HttpSession session,User user){
        User u = (User)session.getAttribute(Const.CURRENTUSER);
        if(u == null){
            return ServerResponse.serverResponseByError("用户未登录");
        }
        user.setId(u.getId());
        ServerResponse serverResponse = iUserService.updateInformation(user);
        if(serverResponse.isSuccess()){
            User user1 = iUserService.getInformationById(user.getId());
            user1.setPassword("");
            session.setAttribute(Const.CURRENTUSER,user1);
        }
        return serverResponse;
    }

    /**
     * 获取用户详细信息
     */
    @RequestMapping(value = "getInformation.do")
    public ServerResponse getInformation(HttpSession session){
        User user = (User)session.getAttribute(Const.CURRENTUSER);
        if(user == null){
            return ServerResponse.serverResponseByError("用户未登录");
        }
        user.setPassword("");
        return ServerResponse.serverResponseBySuccess(user);
    }

    /**
     * 退出登录
     */
    @RequestMapping(value = "logout.do")
    public ServerResponse logout(HttpSession session){

        session.removeAttribute(Const.CURRENTUSER);
        return ServerResponse.serverResponseBySuccess("退出成功");
    }
}
