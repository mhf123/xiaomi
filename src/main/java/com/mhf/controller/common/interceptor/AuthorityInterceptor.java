package com.mhf.controller.common.interceptor;

import com.google.gson.Gson;
import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class AuthorityInterceptor implements HandlerInterceptor {
    @Autowired
    IUserService iUserService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Const.CURRENTMANAGERUSER);

        if (user == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null && cookies.length > 0) {
                for (Cookie cookie : cookies) {
                    String name = cookie.getName();
                    if (name.equals(Const.MANAGERAUTOLOGINCOOKIE)) {
                        String autoLoginToken = cookie.getValue();
                        //根据token查询用户信息
                        user = iUserService.findUserByToken(autoLoginToken);
                        if (user != null && user.getRole() == Const.RoleEnum.ROLE_ADMIN.getCode()) {
                            session.setAttribute(Const.CURRENTMANAGERUSER, user);
                        }
                        break;
                    }
                }
            }
        }
        //重构HttpServletResponse
        if (user == null) {
            response.reset();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter printWriter = response.getWriter();
            if (user == null) {
                ServerResponse serverResponse = ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
                Gson gson = new Gson();
                String s = gson.toJson(serverResponse);
                printWriter.write(s);
            } else {
                ServerResponse serverResponse = ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NO_PRIVILEGE.getCode(), Const.ResponseCodeEnum.NO_PRIVILEGE.getDesc());
                Gson gson = new Gson();
                String s = gson.toJson(serverResponse);
                printWriter.write(s);
            }
            printWriter.flush();
            printWriter.close();
            return false;
        }


        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
