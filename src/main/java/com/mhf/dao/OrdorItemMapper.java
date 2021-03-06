package com.mhf.dao;

import com.mhf.pojo.OrderItem;
import com.mhf.pojo.XiaomiOrder;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrdorItemMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order_item
     *
     * @mbg.generated
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order_item
     *
     * @mbg.generated
     */
    int insert(OrderItem record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order_item
     *
     * @mbg.generated
     */
    OrderItem selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order_item
     *
     * @mbg.generated
     */
    List<OrderItem> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order_item
     *
     * @mbg.generated
     */
    int updateByPrimaryKey(OrderItem record);

    /**
     * 订单明细批量插入
     */
    int insertBatch(List<OrderItem> orderItemList);

    /**
     * 根据userId查购物车订单明细
     */
    List<OrderItem> findListByUserId(Integer userId);

    /**
     * 根据orderNo查询订单明细
     */
    List<OrderItem> findOrderByOrderNo(Long orderNo);


}