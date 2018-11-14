package com.mhf.controller.common.interceptor;

import com.google.gson.Gson;
import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class AuthorityInterceptor2 implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Const.CURRENTUSER);
        //重构HttpServletResponse
        if (user == null) {
            response.reset();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter printWriter = response.getWriter();

            ServerResponse serverResponse = ServerResponse.serverResponseByError(Const.ResponseCodeEnum.NEED_LOGIN.getCode(), Const.ResponseCodeEnum.NEED_LOGIN.getDesc());
            Gson gson = new Gson();
            String s = gson.toJson(serverResponse);
            printWriter.write(s);
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
