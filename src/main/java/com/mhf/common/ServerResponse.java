package com.mhf.common;

/**
 * 服务端返回到前端的高复用对象
 */

public class ServerResponse<T> {
    private int status;//状态码
    private T data;//数据
    private String msg;//错误信息


    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    /**
     * 构造方法
     */
    private ServerResponse() {
    }

    private ServerResponse(int status) {
        this.status = status;
    }

    private ServerResponse(int status, T data) {
        this.status = status;
        this.data = data;
    }

    private ServerResponse(int status, String msg) {
        this.status = status;
        this.msg = msg;
    }

    public ServerResponse(int status, T data, String msg) {
        this.status = status;
        this.data = data;
        this.msg = msg;
    }

    @Override
    public String toString() {
        return "ServerResponse{" +
                "status=" + status +
                ", data=" + data +
                ", msg='" + msg + '\'' +
                '}';
    }

    /**
     * 调用接口成功回调
     *
     * @return
     */
    public static ServerResponse serverResponseBySuccess() {
        return new ServerResponse(ResponseCode.SUCCESS);
    }

    public static <T> ServerResponse serverResponseBySuccess(T data) {
        return new ServerResponse(ResponseCode.SUCCESS, data);
    }

    public static <T> ServerResponse serverResponseBySuccess(T data, String msg) {
        return new ServerResponse(ResponseCode.SUCCESS, data, msg);
    }

    /**
     * 调用接口失败回调
     *
     * @return
     */
    public static ServerResponse serverResponseByError() {
        return new ServerResponse(ResponseCode.Error);
    }

    public static ServerResponse serverResponseByError(int status) {
        return new ServerResponse(status);
    }

    public static ServerResponse serverResponseByError(String msg) {
        return new ServerResponse(ResponseCode.Error, msg);
    }

    public static ServerResponse serverResponseByError(int status, String msg) {
        return new ServerResponse(status, msg);
    }

    /**
     * 判断接口是否正确返回
     */
    public boolean isSuccess() {
        return this.status == ResponseCode.SUCCESS;
    }

}
