package com.mhf.service.impl;

import com.google.common.collect.Sets;
import com.mhf.common.ServerResponse;
import com.mhf.dao.CategoryMapper;
import com.mhf.pojo.Category;
import com.mhf.service.ICategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Service
public class CategoryServiceImpl implements ICategoryService {
    @Autowired
    CategoryMapper categoryMapper;

    @Override
    public ServerResponse getCategory(Integer id) {
        // 1、非空校验
        if(id == null){
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、根据id查询类别
        Category category = categoryMapper.selectByPrimaryKey(id);
        if(category == null){
            return ServerResponse.serverResponseByError("查询类别不存在");
        }
        // 3、查询子类别
        List<Category> childCategory = categoryMapper.getChildCategory(id);
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(childCategory);
    }

    @Transactional
    @Override
    public ServerResponse addCategory(Integer parentId, String categoryName) {
        // 1、参数非空校验
        if(categoryName == null || categoryName.equals("")){
            return ServerResponse.serverResponseByError("类别名称不能为空");
        }
        // 2、判断要添加的节点名称是否已经存在
        int result1 = categoryMapper.selectByCategoryName(categoryName);
        if(result1 > 0){
            //已经存在
            return ServerResponse.serverResponseByError("当前类别名称已经存在");
        }

        // 3、添加节点
        Category category = new Category();
        category.setName(categoryName);
        category.setParentId(parentId);
        category.setStatus(1);
        int result = categoryMapper.insert(category);
        if(result > 0){
            //添加成功
            return ServerResponse.serverResponseBySuccess();
        }
        // 4、返回结果
        return ServerResponse.serverResponseByError("添加失败");
    }

    @Transactional
    @Override
    public ServerResponse setCategoryName(Integer categoryId, String categoryName) {
        // 1、参数非空校验
        if(categoryName == null || categoryName.equals("")){
            return ServerResponse.serverResponseByError("类别名称不能为空");
        }
        if(categoryId == null){
            return ServerResponse.serverResponseByError("类别id不能为空");
        }
        // 2、根据id查询
        Category category = categoryMapper.selectByPrimaryKey(categoryId);
        if(category == null){
            return ServerResponse.serverResponseByError("要修改的类别不存在");
        }
        // 3、修改名称
        category.setName(categoryName);
        int result = categoryMapper.updateByPrimaryKey(category);
        if(result > 0){
            //修改成功
            return ServerResponse.serverResponseBySuccess();
        }
        // 4、返回结果
        return ServerResponse.serverResponseByError("修改失败");
    }

    @Override
    public ServerResponse getDeepCategory(Integer categoryId) {
        // 1、参数非空校验
        if(categoryId == null){
            return ServerResponse.serverResponseByError("类别id不能为空");
        }
        // 2、查询
        Set<Category> categorySet = Sets.newHashSet();
        categorySet = findAllChildCategory(categorySet, categoryId);

        Set<Integer> integerSet = Sets.newHashSet();

        Iterator<Category> categoryIterator = categorySet.iterator();
        while (categoryIterator.hasNext()){
            Category category = categoryIterator.next();
            integerSet.add(category.getId());
        }

        return ServerResponse.serverResponseBySuccess(integerSet);
    }

    private Set<Category> findAllChildCategory(Set<Category> categorySet,Integer categoryId){
        Category category = categoryMapper.selectByPrimaryKey(categoryId);
        if(category != null){
            categorySet.add(category);
        }
        //查找id下的子节点（平级）
        List<Category> childCategoryList = categoryMapper.getChildCategory(categoryId);
        if(childCategoryList != null && childCategoryList.size() > 0){
            for (Category category1 : childCategoryList) {
                findAllChildCategory(categorySet,category1.getId());
            }
        }
        return categorySet;
    }
}
