package com.mhf.dao;

import com.mhf.pojo.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

public interface ProductMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table product
     *
     * @mbg.generated
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table product
     *
     * @mbg.generated
     */
    int insert(Product record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table product
     *
     * @mbg.generated
     */
    Product selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table product
     *
     * @mbg.generated
     */
    List<Product> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table product
     *
     * @mbg.generated
     */
    int updateByPrimaryKey(Product record);

    /**
     * 更新商品
     */
    int updateProduct(Product product);

    /**
     * 通过id或name模糊查询
     */
    List<Product> findProductByIdOrName(@Param("productId") Integer productId,
                                        @Param("productName") String productName,
                                        @Param("status") Integer status);

    /**
     * 前台—搜索商品
     */
    List<Product> searchProduct(@Param("integerSet")Set<Integer> integerSet,
                                @Param("keyword")String keyword,
                                @Param("orderBy")String orderBy);

    /**
     * 后台—根据商品name、detail、color查询
     */
    int selectByNameAndDetailAndColor(Product product);

    /**
     * 根据商品id查询商品库存
     */
    Integer findStockById(Integer id);

    /**
     * 根据分类查找商品名称列表
     */
    List<Product> nameList(@Param("integerSet")Set<Integer> integerSet,
                           @Param("orderBy")String orderBy);

    /**
     * 按需查询未下架的商品列表
     */
    List<Product> selectByDemand(@Param("productName")String productName,
                                 @Param("detail")String detail,
                                 @Param("color")String color);

    /**
     * 按关键字模糊查询未下架的商品名称列表
     */
    List<Product> selectSuggestListByKeyword(String keyword);
}