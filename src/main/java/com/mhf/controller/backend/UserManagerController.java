package com.mhf.controller.backend;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import com.mhf.utils.IPUtils;
import com.mhf.utils.MD5Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.SocketException;
import java.net.UnknownHostException;

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
    @RequestMapping(value = "/login/{username}/{password}")
    public ServerResponse login(HttpServletRequest request, HttpServletResponse response, HttpSession session, @PathVariable("username") String username, @PathVariable("password") String password) {
        ServerResponse serverResponse = iUserService.login(username, password);
        if (serverResponse.isSuccess()) {
            User user = (User) serverResponse.getData();
            // 检查权限
            if (user.getRole() == Const.RoleEnum.ROLE_CUS.getCode()) {
                return ServerResponse.serverResponseByError("用户名或密码错误");
            }
            session.setAttribute(Const.CURRENTMANAGERUSER, user);
            //生成自动登录autoLoginToken
            String ip = IPUtils.getRemoteAddress(request);
            try {
                String mac = IPUtils.getMACAddress(ip);
                String token = MD5Utils.GetMD5Code(mac);
                //把token保存到数据库
                iUserService.saveTokenByUserId(user.getId(), token);
                //token作为cookie响应到客户端
                Cookie cookie = new Cookie(Const.MANAGERAUTOLOGINCOOKIE, token);
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
     * 获取登录管理员用户信息
     */
    @RequestMapping(value = "getUser")
    public ServerResponse getUser(HttpSession session) {

        User user = (User) session.getAttribute(Const.CURRENTMANAGERUSER);
        if (user == null) {
            return ServerResponse.serverResponseByError("未登录");
        }

        User newuser = new User();
        newuser.setId(user.getId());
        newuser.setUsername(user.getUsername());
        newuser.setPhone(user.getPhone());
        newuser.setEmail(user.getEmail());
        return ServerResponse.serverResponseBySuccess(newuser);
    }

    /**
     * 退出登录
     */
    @RequestMapping(value = "logout")
    public ServerResponse logout(HttpSession session, HttpServletRequest request) {
        User user = (User) session.getAttribute(Const.CURRENTMANAGERUSER);
        //删除token
        ServerResponse serverResponse = iUserService.logout(user);
        //清除cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                if (name.equals(Const.MANAGERAUTOLOGINCOOKIE)) {
                    cookie.setMaxAge(0);
                    break;
                }
            }
        }
        session.removeAttribute(Const.CURRENTMANAGERUSER);

        return serverResponse;
    }
}
