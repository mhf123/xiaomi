package com.mhf.pojo;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Date;
@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
public class Payinfo {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.id
     *
     * @mbg.generated
     */
    private Integer id;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.user_id
     *
     * @mbg.generated
     */
    private Integer userId;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.order_no
     *
     * @mbg.generated
     */
    private Long orderNo;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.pay_platform
     *
     * @mbg.generated
     */
    private Integer payPlatform;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.platform_number
     *
     * @mbg.generated
     */
    private String platformNumber;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.platform_status
     *
     * @mbg.generated
     */
    private String platformStatus;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.create_time
     *
     * @mbg.generated
     */
    private Date createTime;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column payinfo.update_time
     *
     * @mbg.generated
     */
    private Date updateTime;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.id
     *
     * @return the value of payinfo.id
     *
     * @mbg.generated
     */
    public Integer getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.id
     *
     * @param id the value for payinfo.id
     *
     * @mbg.generated
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.user_id
     *
     * @return the value of payinfo.user_id
     *
     * @mbg.generated
     */
    public Integer getUserId() {
        return userId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.user_id
     *
     * @param userId the value for payinfo.user_id
     *
     * @mbg.generated
     */
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.order_no
     *
     * @return the value of payinfo.order_no
     *
     * @mbg.generated
     */
    public Long getOrderNo() {
        return orderNo;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.order_no
     *
     * @param orderNo the value for payinfo.order_no
     *
     * @mbg.generated
     */
    public void setOrderNo(Long orderNo) {
        this.orderNo = orderNo;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.pay_platform
     *
     * @return the value of payinfo.pay_platform
     *
     * @mbg.generated
     */
    public Integer getPayPlatform() {
        return payPlatform;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.pay_platform
     *
     * @param payPlatform the value for payinfo.pay_platform
     *
     * @mbg.generated
     */
    public void setPayPlatform(Integer payPlatform) {
        this.payPlatform = payPlatform;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.platform_number
     *
     * @return the value of payinfo.platform_number
     *
     * @mbg.generated
     */
    public String getPlatformNumber() {
        return platformNumber;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.platform_number
     *
     * @param platformNumber the value for payinfo.platform_number
     *
     * @mbg.generated
     */
    public void setPlatformNumber(String platformNumber) {
        this.platformNumber = platformNumber == null ? null : platformNumber.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.platform_status
     *
     * @return the value of payinfo.platform_status
     *
     * @mbg.generated
     */
    public String getPlatformStatus() {
        return platformStatus;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.platform_status
     *
     * @param platformStatus the value for payinfo.platform_status
     *
     * @mbg.generated
     */
    public void setPlatformStatus(String platformStatus) {
        this.platformStatus = platformStatus == null ? null : platformStatus.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.create_time
     *
     * @return the value of payinfo.create_time
     *
     * @mbg.generated
     */
    public Date getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.create_time
     *
     * @param createTime the value for payinfo.create_time
     *
     * @mbg.generated
     */
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column payinfo.update_time
     *
     * @return the value of payinfo.update_time
     *
     * @mbg.generated
     */
    public Date getUpdateTime() {
        return updateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column payinfo.update_time
     *
     * @param updateTime the value for payinfo.update_time
     *
     * @mbg.generated
     */
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}