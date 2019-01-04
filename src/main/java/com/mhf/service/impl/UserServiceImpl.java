package com.mhf.service.impl;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.dao.UserMapper;
import com.mhf.pojo.User;
import com.mhf.service.IUserService;
import com.mhf.utils.MD5Utils;
import com.mhf.utils.RedisPoolUtils;
import com.mhf.utils.TokenCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import redis.clients.jedis.Jedis;

import javax.servlet.http.HttpSession;
import java.util.UUID;

@Service
public class UserServiceImpl implements IUserService {

    @Autowired
    UserMapper userMapper;

    @Override
    public ServerResponse login(String username, String password) {
        // 1、非空校验
        if (username == null || username.equals("")) {
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if (username == password || password.equals("")) {
            return ServerResponse.serverResponseByError("密码不能为空");
        }
        // 2、检查用户名或手机号是否存在
        int result = userMapper.checkUsernameOrPhone(username);
        if (result == 0) {
            return ServerResponse.serverResponseByError("用户名不存在");
        }
        // 3、根据用户名/手机号-密码查找信息
        User user = userMapper.selectUserByUsernameOrPhoneAndPassword(username, MD5Utils.GetMD5Code(password));

        if (user == null) {
            return ServerResponse.serverResponseByError("用户名或密码错误");
        } else {
            user.setPassword("");
        }
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(user);
    }

    @Override
    public ServerResponse loginByPhone(String phone) {
        // 1、非空校验
        if (phone == null || phone.equals("")) {
            return ServerResponse.serverResponseByError("手机号不能为空");
        }
        // 2、检查手机号是否存在
        int result = userMapper.checkPhone(phone);
        if (result == 0) {
            return ServerResponse.serverResponseByError("手机号不存在");
        }
        // 3、根据手机号查找信息
        User user = userMapper.selectUserByPhone(phone);

        if (user == null) {
            return ServerResponse.serverResponseByError("无此用户");
        } else {
            user.setPassword("");
        }
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(user);
    }

    @Transactional
    @Override
    public ServerResponse register(User user) {
        // 1、非空校验
        if (user == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、校验手机号
        int resultUsername = userMapper.checkPhone(user.getPhone());
        if (resultUsername > 0) {
            return ServerResponse.serverResponseByError("当前手机号已被注册");
        }
        // 3、校验邮箱
//        int resultEmail = userMapper.checkEmail(user.getEmail());
//        if (resultEmail > 0) {
//            return ServerResponse.serverResponseByError("邮箱已存在");
//        }
        // 4、注册
        //设置权限
        user.setRole(Const.RoleEnum.ROLE_CUS.getCode());
        // 加密
        String pass = user.getPassword();
        user.setPassword(MD5Utils.GetMD5Code(pass));
        int count = userMapper.insert(user);
        if (count > 0) {
            return ServerResponse.serverResponseBySuccess("注册成功");
        }
        // 5、返回结果
        return ServerResponse.serverResponseByError("注册失败");
    }

    @Override
    public ServerResponse getQuestion(String username) {
        // 1、非空校验
        if (username == null || username.equals("")) {
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        // 2、校验用户名
        int count = userMapper.checkUsername(username);
        if (count == 0) {
            return ServerResponse.serverResponseByError("用户名不存在，请重新输入");
        }
        // 3、查找密保问题
        String question = userMapper.selectQuestionByUsername(username);
        if (question == null || question.equals("")) {
            return ServerResponse.serverResponseByError("密保问题为空");
        }
        return ServerResponse.serverResponseBySuccess(question);
    }

    @Override
    public ServerResponse checkAnswer(String username, String question, String answer) {
        // 1、非空校验
        if (username == null || username.equals("")) {
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if (question == null || question.equals("")) {
            return ServerResponse.serverResponseByError("问题不能为空");
        }
        if (answer == null || answer.equals("")) {
            return ServerResponse.serverResponseByError("答案不能为空");
        }
        // 2、校验密保答案
        int result = userMapper.checkAnswer(username, question, answer);
        if (result == 0) {
            return ServerResponse.serverResponseByError("答案错误");
        }
        // 3、服务端生成一个token保存，并返回给客户端
        String forgetToken = UUID.randomUUID().toString();

        //放入redis缓存
        RedisPoolUtils.setex(username, forgetToken, 60 * 60);


        return ServerResponse.serverResponseBySuccess(forgetToken);
    }


    @Transactional
    @Override
    public ServerResponse forgetResetPassword(String username, String password, String forgetToken) {
        // 1、非空校验
        if (username == null || username.equals("")) {
            return ServerResponse.serverResponseByError("用户名不能为空");
        }
        if (password == null || password.equals("")) {
            return ServerResponse.serverResponseByError("密码不能为空");
        }
        if (forgetToken == null || forgetToken.equals("")) {
            return ServerResponse.serverResponseByError("token不能为空");
        }
        // 2、校验token
        String token = RedisPoolUtils.get(username);
        if (token == null) {
            return ServerResponse.serverResponseByError("token已过期");
        }
        if (!token.equals(forgetToken)) {
            return ServerResponse.serverResponseByError("token无效");
        }
        // 3、重置密码
        int result = userMapper.updatePassword(username, MD5Utils.GetMD5Code(password));
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        }

        return ServerResponse.serverResponseByError("密码修改失败");
    }

    @Override
    public ServerResponse checkValid(String str, String type) {

        // 1、参数非空校验
        if (str == null || str.equals("")) {
            return ServerResponse.serverResponseByError("用户名或邮箱不能为空");
        }
        if (type == null || type.equals("")) {
            return ServerResponse.serverResponseByError("类型参数不能为空");
        }
        // 2、 phone ---- 校验手机号 str
        //     email ------ 校验邮箱 str
        //     username ---- 校验用户名 str
        if (type.equals("phone")) {
            int result = userMapper.checkPhone(str);
            if (result > 0) {
                return ServerResponse.serverResponseByError("当前手机号已被注册");
            } else {
                return ServerResponse.serverResponseBySuccess();
            }
        } else if (type.equals("email")) {
            int result = userMapper.checkEmail(str);
            if (result > 0) {
                return ServerResponse.serverResponseByError("邮箱已存在");
            } else {
                return ServerResponse.serverResponseBySuccess();
            }
        } else if (type.equals("username")) {
            int result = userMapper.checkUsername(str);
            if (result > 0) {
                return ServerResponse.serverResponseByError("用户名已存在");
            } else {
                return ServerResponse.serverResponseBySuccess();
            }
        }
        return ServerResponse.serverResponseByError("参数类型错误");
    }


    @Transactional
    @Override
    public ServerResponse loginResetPassword(String username, String oldPassword, String newPassword) {
        // 1、参数非空校验
        if (oldPassword == null || oldPassword.equals("")) {
            return ServerResponse.serverResponseByError("旧密码不能为空");
        }
        if (newPassword == null || newPassword.equals("")) {
            return ServerResponse.serverResponseByError("新密码不能为空");
        }
        // 2、根据用户名和旧密码进行判断
        User user = userMapper.selectUserByUsernameAndPassword(username, MD5Utils.GetMD5Code(oldPassword));
        if (user == null) {
            return ServerResponse.serverResponseByError("旧密码错误");
        }
        // 3、修改密码
        user.setPassword(MD5Utils.GetMD5Code(newPassword));
        int result = userMapper.updateByPrimaryKey(user);
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess("修改成功");
        }
        return ServerResponse.serverResponseByError("密码修改失败");
    }

    @Transactional
    @Override
    public ServerResponse updateInformation(User user) {
        // 1、参数校验
        if (user == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、更新用户信息
        int result = userMapper.updateInformation(user);
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        }
        return ServerResponse.serverResponseBySuccess("更新个人信息失败");
    }

    @Override
    public User getInformationById(Integer userId) {
        User user = userMapper.selectByPrimaryKey(userId);
        return user;
    }

    @Transactional
    @Override
    public int saveTokenByUserId(Integer userId, String token) {
        int result = userMapper.saveTokenByUserId(userId, token);
        return result;
    }

    @Override
    public User findUserByToken(String token) {
        if (token == null || token.equals(""))
            return null;
        User user = userMapper.findUserByToken(token);
        return user;
    }

    @Override
    public ServerResponse logout(User user) {
        // 1、修改当前用户的token为空
        if (user == null) {
            return ServerResponse.serverResponseByError("用户未登录");
        }
        user.setToken("");

        int result = userMapper.updateTokenByUserId(user);
        // 2、返回结果
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess("退出登录成功");

        }
        return ServerResponse.serverResponseByError("退出登录失败");
    }

    @Override
    public ServerResponse loginCheckPhone(String phone) {
        // 1、参数非空校验
        if (phone == null || phone.equals("")) {
            return ServerResponse.serverResponseByError("手机号码不能为空");
        }
        // 2、校验手机号
        int result = userMapper.checkPhone(phone);
        if (result == 0) {
            return ServerResponse.serverResponseByError("当前手机号未注册");
        } else {
            return ServerResponse.serverResponseBySuccess();
        }
    }

    @Override
    public ServerResponse resetPasswordByPhone(String phone, String password) {
        // 1、非空校验
        if (phone == null || phone.equals("")) {
            return ServerResponse.serverResponseByError("手机号不能为空");
        }
        if (password == null || password.equals("")) {
            return ServerResponse.serverResponseByError("密码不能为空");
        }

        // 2、重置密码
        int result = userMapper.updatePasswordByPhone(phone, MD5Utils.GetMD5Code(password));
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        }

        return ServerResponse.serverResponseByError("密码修改失败");
    }


}
