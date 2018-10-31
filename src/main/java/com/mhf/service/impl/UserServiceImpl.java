package com.mhf.service.impl;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.dao.UserMapper;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import com.mhf.utils.MD5Utils;
import com.mhf.utils.TokenCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserServiceImpl implements IUserService {

    @Autowired
    UserMapper userMapper;

    @Override
    public ServerResponse login(String username, String password) {
        // 1、非空校验
        if(username == null || username.equals("")){
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if(username == password || password.equals("")){
            return ServerResponse.serverResponseByError("密码不能为空");
        }
        // 2、检查用户名是否存在
        int result = userMapper.checkUsername(username);
        if(result == 0){
            return ServerResponse.serverResponseByError("用户名不存在");
        }
        // 3、根据用户名密码查找信息
        User user = userMapper.selectUserByUsernameAndPassword(username,MD5Utils.GetMD5Code(password));
        user.setPassword("");
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(user);
    }

    @Override
    public ServerResponse register(User user) {
        // 1、非空校验
        if(user == null){
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、校验用户名
        int resultUsername = userMapper.checkUsername(user.getUsername());
        if(resultUsername > 0){
            return ServerResponse.serverResponseByError("用户名已存在");
        }
        // 3、校验邮箱
        int resultEmail = userMapper.checkEmail(user.getEmail());
        if(resultEmail > 0){
            return ServerResponse.serverResponseByError("邮箱已存在");
        }
        // 4、注册
        //设置权限
        user.setRole(Const.RoleEnum.ROLE_CUS.getCode());
        // 加密
        String pass = user.getPassword();
        user.setPassword(MD5Utils.GetMD5Code(pass));
        int count = userMapper.insert(user);
        if(count > 0){
                return ServerResponse.serverResponseBySuccess("注册成功");
        }
        // 5、返回结果
        return ServerResponse.serverResponseByError("注册失败");
    }

    @Override
    public ServerResponse getQuestion(String username) {
        // 1、非空校验
        if(username == null || username.equals("")){
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        // 2、校验用户名
        int count = userMapper.checkUsername(username);
        if(count == 0){
            return ServerResponse.serverResponseByError("用户名不存在，请重新输入");
        }
        // 3、查找密保问题
        String question = userMapper.selectQuestionByUsername(username);
        if(question == null || question.equals("")){
            return ServerResponse.serverResponseByError("密保问题为空");
        }
        return ServerResponse.serverResponseBySuccess(question);
    }

    @Override
    public ServerResponse checkAnswer(String username, String question, String answer) {
        // 1、非空校验
        if(username == null || username.equals("")){
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if(question == null || question.equals("")){
            return ServerResponse.serverResponseByError("问题不能为空");
        }
        if(answer == null || answer.equals("")){
            return ServerResponse.serverResponseByError("答案不能为空");
        }
        // 2、校验密保答案
        int result = userMapper.checkAnswer(username,question,answer);
        if(result == 0){
            return ServerResponse.serverResponseByError("答案错误");
        }
        // 3、服务端生成一个token保存，并返回给客户端
        String forgetToken = UUID.randomUUID().toString();
        TokenCache.set(username,forgetToken);

        return ServerResponse.serverResponseBySuccess(forgetToken);
    }

    @Override
    public ServerResponse resetPassword(String username, String password, String forgetToken) {
        // 1、非空校验
        if(username == null || username.equals("")){
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if(password == null || password.equals("")) {
            return ServerResponse.serverResponseByError("密码不能为空");
        }
        if(forgetToken == null || forgetToken.equals("")){
            return ServerResponse.serverResponseByError("token不能为空");
        }
        // 2、校验token
        String token = TokenCache.get(username);
        if(token == null){
            return ServerResponse.serverResponseByError("token已过期");
        }
        if(!token.equals(forgetToken)){
            return ServerResponse.serverResponseByError("token无效");
        }
        // 3、重置密码
        int result = userMapper.updatePassword(username, MD5Utils.GetMD5Code(password));
        if(result > 0){
            return ServerResponse.serverResponseBySuccess();
        }

        return ServerResponse.serverResponseByError("密码修改失败");
    }
}
