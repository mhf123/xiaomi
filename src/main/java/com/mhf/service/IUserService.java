package com.mhf.service;

import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;

public interface IUserService {
    /**
     * 登录接口
     */
    ServerResponse login(String username, String password);

    /**
     * 注册接口
     */
    ServerResponse register(User user);

    /**
     * 根据用户名找回密保问题接口
     */
    ServerResponse getQuestion(String username);

    /**
     * 提交密保问题答案接口
     */
    ServerResponse checkAnswer(String username,String question,String answer);

    /**
     * 重置密码接口
     */
    ServerResponse resetPassword(String username,String password,String forgetToken);
}
