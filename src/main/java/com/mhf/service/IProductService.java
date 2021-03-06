package com.mhf.service;

import com.mhf.common.ServerResponse;
import com.mhf.pojo.Product;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public interface IProductService {
    /**
     * 新增OR更新商品接口
     */
    ServerResponse saveOrUpdate(Product product);

    /**
     * 产品上下架接口
     */
    ServerResponse setSaleStatus(Integer productId, Integer status);

    /**
     * 后台-商品详情接口
     */
    ServerResponse detail(Integer productId);

    /**
     * 后台-商品列表接口（分页）
     */
    ServerResponse list(Integer pageNum, Integer pageSize);

    /**
     * 后台-搜索商品
     */
    ServerResponse search(Integer productId, String productName, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 图片上传
     */
    Map<String, String> upload(MultipartFile file, String path);

    /**
     * 前台-商品详情
     */
    ServerResponse detailPortal(Integer productId);

    /**
     * 前台-商品搜索
     */
    ServerResponse listPortal(Integer categoryId, String keyword, Integer pageNum, Integer pageSize, String orderBy);

    /**
     * 根据分类查找商品名称列表接口
     */
    ServerResponse nameList(Integer categoryId, Integer pageNum, Integer pageSize, String orderBy);

    /**
     * 按需查询商品列表
     */
    ServerResponse listByDemand(String productName, String detail, String color);

    /**
     * 商品搜索提示
     */
    ServerResponse suggestList(String keyword, Integer pageNum, Integer pageSize, String orderBy);
}
