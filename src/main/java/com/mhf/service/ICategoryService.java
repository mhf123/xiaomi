package com.mhf.service;

import com.mhf.common.ServerResponse;

/**
 * 商品分类接口
 */
public interface ICategoryService {
    /**
     * 获取分类子节点
     */
    ServerResponse getCategory(Integer id);

    /**
     * 增加分类节点
     */
    ServerResponse addCategory(Integer parentId, String categoryName);

    /**
     * 修改分类节点名称
     */
    ServerResponse setCategoryName(Integer categoryId, String categoryName);

    /**
     * 获取当前分类id以及递归子节点
     */
    ServerResponse getDeepCategory(Integer categoryId);
}
