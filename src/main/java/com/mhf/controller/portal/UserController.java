package com.mhf.controller.portal;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.gson.Gson;
import com.httpApiDemo.IndustrySMS;
import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import com.mhf.utils.IPUtils;
import com.mhf.utils.MD5Utils;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.SocketException;
import java.net.UnknownHostException;

@RestController
@RequestMapping(value = "/user")

@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
public class UserController {

    @Autowired
    IUserService iUserService;

    /**
     * 通过密码登录
     */
    @RequestMapping(value = "/login/{username}/{password}")
    public ServerResponse login(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                                @PathVariable("username") String username,
                                @PathVariable("password") String password) {

        ServerResponse serverResponse = iUserService.login(username, password);
        if (serverResponse.isSuccess()) {
            User user = (User) serverResponse.getData();
            session.setAttribute(Const.CURRENTUSER, user);
            //生成自动登录autoLoginToken
            String ip = IPUtils.getRemoteAddress(request);
            try {
                String mac = IPUtils.getMACAddress(ip);
                String token = MD5Utils.GetMD5Code(mac + user.getUsername());
                //把token保存到数据库
                iUserService.saveTokenByUserId(user.getId(), token);
                //token作为cookie响应到客户端
                Cookie cookie = new Cookie(Const.AUTOLOGINCOOKIE, token);
                cookie.setPath("/");
                //设置时长7天
                cookie.setMaxAge(60 * 60 * 24 * 7);
                response.addCookie(cookie);

            } catch (UnknownHostException e) {
                e.printStackTrace();
            } catch (SocketException e) {
                e.printStackTrace();
            }
        }
        return serverResponse;
    }

    /**
     * 通过手机验证码登录
     */
    @RequestMapping(value = "/loginByPhone/{phone}")
    public ServerResponse loginByPhone(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                                       @PathVariable("phone") String phone) {

        ServerResponse serverResponse = iUserService.loginByPhone(phone);
        if (serverResponse.isSuccess()) {
            User user = (User) serverResponse.getData();
            session.setAttribute(Const.CURRENTUSER, user);
            //生成自动登录autoLoginToken
            String ip = IPUtils.getRemoteAddress(request);
            try {
                String mac = IPUtils.getMACAddress(ip);
                String token = MD5Utils.GetMD5Code(mac + user.getUsername());
                //把token保存到数据库
                iUserService.saveTokenByUserId(user.getId(), token);
                //token作为cookie响应到客户端
                Cookie cookie = new Cookie(Const.AUTOLOGINCOOKIE, token);
                cookie.setPath("/");
                //设置时长7天
                cookie.setMaxAge(60 * 60 * 24 * 7);
                response.addCookie(cookie);

            } catch (UnknownHostException e) {
                e.printStackTrace();
            } catch (SocketException e) {
                e.printStackTrace();
            }
        }
        return serverResponse;
    }

    /**
     * 注册
     */
    @RequestMapping(value = "/register")
    public ServerResponse register(User user) {
        ServerResponse serverResponse = iUserService.register(user);
        return serverResponse;
    }

    /**
     * 根据用户名找回密保问题
     */
    @RequestMapping(value = "getQuestion/{username}")
    public ServerResponse getQuestion(@PathVariable("username") String username) {
        ServerResponse serverResponse = iUserService.getQuestion(username);
        return serverResponse;
    }

    /**
     * 提交密保问题答案，并验证
     */
    @RequestMapping(value = "checkAnswer/{username}/{question}/{answer}")
    public ServerResponse checkAnswer(@PathVariable("username") String username,
                                      @PathVariable("question") String question,
                                      @PathVariable("answer") String answer) {
        ServerResponse serverResponse = iUserService.checkAnswer(username, question, answer);
        return serverResponse;
    }

    /**
     * 忘记密码通过手机验证码重置密码
     */
    @RequestMapping(value = "resetPasswordByPhone/{phone}/{password}")
    public ServerResponse resetPasswordByPhone(@PathVariable("phone") String phone,
                                        @PathVariable("password") String password) {
        ServerResponse serverResponse = iUserService.resetPasswordByPhone(phone, password);
        return serverResponse;
    }

    /**
     * 忘记密码重置密码
     */
    @RequestMapping(value = "resetPassword/{username}/{password}/{forgetToken}")
    public ServerResponse resetPassword(@PathVariable("username") String username,
                                        @PathVariable("password") String password,
                                        @PathVariable("forgetToken") String forgetToken) {
        ServerResponse serverResponse = iUserService.forgetResetPassword(username, password, forgetToken);
        return serverResponse;
    }

    /**
     * 检查用户名和邮箱是否有效
     */
    @RequestMapping(value = "checkValid/{str}/{type}")
    public ServerResponse checkValid(@PathVariable("str") String str,
                                     @PathVariable("type") String type) {
        ServerResponse serverResponse = iUserService.checkValid(str, type);
        return serverResponse;
    }

    /**
     * 登录时检查手机号是否有效
     */
    @RequestMapping(value = "loginCheckPhone/{phone}")
    public ServerResponse loginCheckPhone(@PathVariable("phone") String phone) {
        System.out.println(1);
        ServerResponse serverResponse = iUserService.loginCheckPhone(phone);
        return serverResponse;
    }

    /**
     * 获取登录用户信息
     */
    @RequestMapping(value = "getUser")
    public ServerResponse getUser(HttpSession session) {

        User user = (User) session.getAttribute(Const.CURRENTUSER);

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
    @RequestMapping(value = "loginResetPassword/{oldPassword}/{newPassword}")
    public ServerResponse loginResetPassword(HttpSession session,
                                             @PathVariable("oldPassword") String oldPassword,
                                             @PathVariable("newPassword") String newPassword) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        ServerResponse serverResponse = iUserService.loginResetPassword(user.getUsername(), oldPassword, newPassword);
        return serverResponse;
    }

    /**
     * 登录状态更新个人信息
     */
    @RequestMapping(value = "updateInformation")
    public ServerResponse updateInformation(HttpSession session, User user) {
        User u = (User) session.getAttribute(Const.CURRENTUSER);
        user.setId(u.getId());
        ServerResponse serverResponse = iUserService.updateInformation(user);
        if (serverResponse.isSuccess()) {
            User user1 = iUserService.getInformationById(user.getId());
            user1.setPassword("");
            session.setAttribute(Const.CURRENTUSER, user1);
        }
        return serverResponse;
    }

    /**
     * 获取用户详细信息
     */
    @RequestMapping(value = "getInformation")
    public ServerResponse getInformation(HttpSession session) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);

        user.setPassword("");
        return ServerResponse.serverResponseBySuccess(user);
    }

    /**
     * 退出登录
     */
    @RequestMapping(value = "logout")
    public ServerResponse logout(HttpSession session, HttpServletRequest request) {
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //删除token
        ServerResponse serverResponse = iUserService.logout(user);
        //清除cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                if (name.equals(Const.AUTOLOGINCOOKIE)) {
                    cookie.setMaxAge(0);
                    break;
                }
            }
        }
        session.removeAttribute(Const.CURRENTUSER);

        return serverResponse;
    }

    /**
     * 发送短信验证码
     */
    @RequestMapping(value = "verificationCode/{phone}/{code}")
    public ServerResponse verificationCode(@PathVariable("phone") String phone,
                                           @PathVariable("code") String code) {
        String result = IndustrySMS.execute(phone, code);
        ServerResponse serverResponse = ServerResponse.serverResponseBySuccess(result);
        return serverResponse;
    }
}
