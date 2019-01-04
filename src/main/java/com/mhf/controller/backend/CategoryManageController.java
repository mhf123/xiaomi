package com.mhf.controller.backend;

import com.mhf.common.ServerResponse;
import com.mhf.service.ICategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/manager1/category")
public class CategoryManageController {

    @Autowired
    ICategoryService iCategoryService;

    /**
     * 获取品类子节点（平级）
     */
    @RequestMapping(value = "/getCategory/{id}")
    public ServerResponse getCategory(@PathVariable("id") Integer id) {

        //获取子节点
        ServerResponse category = iCategoryService.getCategory(id);
        return category;
    }

    /**
     * 增加节点
     */
    @RequestMapping(value = "/addCategory")
    public ServerResponse addCategory(@RequestParam(required = false, defaultValue = "0") Integer parentId, String categoryName) {

        //获取子节点
        ServerResponse category = iCategoryService.addCategory(parentId, categoryName);
        return category;
    }

    /**
     * 修改类别名字
     */
    @RequestMapping(value = "/setCategoryName/{categoryId}/{categoryName}")
    public ServerResponse setCategoryName(@PathVariable("categoryId") Integer categoryId,
                                          @PathVariable("categoryName") String categoryName) {

        //获取子节点
        ServerResponse category = iCategoryService.setCategoryName(categoryId, categoryName);
        return category;
    }

    /**
     * 获取当前分类id以及递归子节点
     */
    @RequestMapping(value = "/getDeepCategory/{categoryId}")
    public ServerResponse getDeepCategory(@PathVariable("categoryId") Integer categoryId) {

        //获取子节点
        ServerResponse category = iCategoryService.getDeepCategory(categoryId);
        return category;
    }
}
