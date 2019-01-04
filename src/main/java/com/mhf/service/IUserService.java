package com.mhf.service;

import com.mhf.common.ServerResponse;
import com.mhf.pojo.User;

import javax.servlet.http.HttpSession;

public interface IUserService {
    /**
     * 通过密码登录接口
     */
    ServerResponse login(String username, String password);

    /**
     * 通过手机验证码登录接口
     */
    ServerResponse loginByPhone(String phone);

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
    ServerResponse checkAnswer(String username, String question, String answer);

    /**
     * 忘记密码重置密码接口
     */
    ServerResponse forgetResetPassword(String username, String password, String forgetToken);

    /**
     * 检查用户名和邮箱是否有效接口
     */
    ServerResponse checkValid(String str, String type);

    /**
     * 登录状态重置密码接口
     */
    ServerResponse loginResetPassword(String usernsme, String oldPassword, String newPassword);

    /**
     * 登录状态更新个人信息接口
     */
    ServerResponse updateInformation(User user);

    /**
     * 根据用户id查询用户信息
     */
    User getInformationById(Integer userId);

    /**
     * 保存用户token信息
     */
    int saveTokenByUserId(Integer userId, String token);

    /**
     * 根据token查询用户信息
     */
    User findUserByToken(String token);

    /**
     * 退出登录接口
     */
    ServerResponse logout(User user);

    /**
     * 登录时检查手机号是否有效
     */
    ServerResponse loginCheckPhone(String phone);

    /**
     * 忘记密码通过手机验证码重置密码
     */
    ServerResponse resetPasswordByPhone(String phone, String password);
}
