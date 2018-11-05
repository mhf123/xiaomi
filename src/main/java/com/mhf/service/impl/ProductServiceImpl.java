package com.mhf.service.impl;

 import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
 import com.google.common.collect.Sets;
 import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.dao.CategoryMapper;
import com.mhf.dao.ProductMapper;
import com.mhf.pojo.Category;
import com.mhf.pojo.Product;
import com.mhf.service.ICategoryService;
import com.mhf.service.IProductService;
import com.mhf.utils.DateUtils;
import com.mhf.utils.PropertiesUtils;
import com.mhf.vo.ProductDetailVo;
import com.mhf.vo.ProductListVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
 import java.util.Set;
 import java.util.UUID;

@Service
public class ProductServiceImpl implements IProductService {

    @Autowired
    ProductMapper productMapper;

    @Autowired
    CategoryMapper categoryMapper;

    @Autowired
    ICategoryService iCategoryService;

    @Override
    public ServerResponse saveOrUpdate(Product product) {
        // 1、参数校验
        if (product == null) {
            return ServerResponse.serverResponseByError("参数为空");
        }
        // 2、设置图片的主图（图片第一张->主图）
        String subImages = product.getSubImages();
        if (subImages != null && !subImages.equals("")) {
            String[] subImagesArr = subImages.split(",");
            if (subImagesArr.length > 0) {
                //设置商品主图
                product.setMainImage(subImagesArr[0]);
            }
        }
        // 3、商品更新or新增
        if (product.getId() == null) {
            //判断当前商品是否已经添加
            int result1 = productMapper.selectByName(product.getName());
            if (result1 > 0){
                return ServerResponse.serverResponseByError("当前商品已经添加");
            }
            //新增
            int result = productMapper.insert(product);
            if (result > 0) {
                // 4、返回结果
                return ServerResponse.serverResponseBySuccess();
            } else {
                return ServerResponse.serverResponseByError("添加失败");
            }

        } else {
            //更新
            int result = productMapper.updateByPrimaryKey(product);
            if (result > 0) {
                // 4、返回结果
                return ServerResponse.serverResponseBySuccess();
            } else {
                return ServerResponse.serverResponseByError("更新失败");
            }
        }

    }

    @Override
    public ServerResponse setSaleStatus(Integer productId, Integer status) {
        // 1、参数非空校验
        if (productId == null) {
            return ServerResponse.serverResponseByError("商品id不能为空");
        }
        if (status == null) {
            return ServerResponse.serverResponseByError("商品状态不能为空");
        }
        // 2、更新商品状态
        Product product = new Product();
        product.setId(productId);
        product.setStatus(status);
        int result = productMapper.updateProduct(product);

        // 3、返回结果
        if (result > 0) {
            return ServerResponse.serverResponseBySuccess();
        } else {
            return ServerResponse.serverResponseByError("更新失败");
        }
    }

    @Override
    public ServerResponse detail(Integer productId) {
        // 1、非空校验
        if (productId == null) {
            return ServerResponse.serverResponseByError("商品id不能为空");
        }
        // 2、查询商品
        Product product = productMapper.selectByPrimaryKey(productId);
        if (product == null){
            return ServerResponse.serverResponseByError("商品不存在");
        }
        // 3、转成productDetailVo
        ProductDetailVo productDetailVo = toProductDetailVo(product);
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(productDetailVo);
    }

    @Override
    public ServerResponse list(Integer pageNum, Integer pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        // 1、查询商品数据
        List<Product> products = productMapper.selectAll();
        List<ProductListVo> productListVos = Lists.newArrayList();
        if (products != null && products.size() > 0){
            for (Product product : products) {
                ProductListVo productListVo = toProductListVo(product);
                productListVos.add(productListVo);
            }
        }
        // 2、结果集合转成分页对象，并返回
        PageInfo pageInfo = new PageInfo(productListVos);

        return ServerResponse.serverResponseBySuccess(pageInfo);
    }

    @Override
    public ServerResponse search(Integer productId, String productName, Integer pageNum, Integer pageSize) {
        // 1、分页插件显示、productName非空判断
        PageHelper.startPage(pageNum,pageSize);

        if(productName != null && !productName.equals("")){
            productName = "%" + productName + "%";
        }
        // 2、通过id或name模糊查询
        List<Product> products = productMapper.findProductByIdOrName(productId, productName);
        List<ProductListVo> productListVos = Lists.newArrayList();
        if (products != null && products.size() > 0){
            for (Product product : products) {
                ProductListVo productListVo = toProductListVo(product);
                productListVos.add(productListVo);
            }
        }
        // 2、结果集合转成分页对象,并返回
        PageInfo pageInfo = new PageInfo(productListVos);

        return ServerResponse.serverResponseBySuccess(pageInfo);
    }

    @Override
    public ServerResponse upload(MultipartFile file, String path) {
        // 1、非空校验
        if (file == null) {
            return ServerResponse.serverResponseByError("参数为空");
        }
        // 2、获取并修改图片名字
        //获取图片全名
        String filename = file.getOriginalFilename();
        //获取图片拓展名
        String exName = filename.substring(filename.lastIndexOf("."));
        //生成唯一名字
        String newFileName = UUID.randomUUID().toString() + exName;

        // 3、地址非空校验
        File pathFile = new File(path);
        if(!pathFile.exists()){
            pathFile.setWritable(true);
            pathFile.mkdirs();
        }

        // 4、图片上传
        File file1 = new File(path+newFileName);
        try {
            file.transferTo(file1);
            //上传到图片服务器
            Map<String,String> map = Maps.newHashMap();
            map.put("uri",newFileName);
            map.put("url",PropertiesUtils.readByKey("imageHost")+ "/" + newFileName);
            return ServerResponse.serverResponseBySuccess(map);

        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public ServerResponse detailPortal(Integer productId) {
        // 1、非空校验
        if (productId == null) {
            return ServerResponse.serverResponseByError("参数为空");
        }
        // 2、根据id查询商品
        Product product = productMapper.selectByPrimaryKey(productId);
        if (product == null){
            return ServerResponse.serverResponseByError("商品不存在");
        }
        // 3、校验商品状态是否下架
        if (product.getStatus() != Const.ProductStatusEnum.PRODUCT_ONLINE.getCode()){
            return ServerResponse.serverResponseByError("商品已下架或删除");
        }
        // 4、获取productDetailVo
        ProductDetailVo productDetailVo = toProductDetailVo(product);
        // 5、返回结果
        return ServerResponse.serverResponseBySuccess(productDetailVo);
    }

    @Override
    public ServerResponse listPortal(Integer categoryId, String keyword, Integer pageNum, Integer pageSize, String orderBy) {
        // 1、参数非空校验（productId和keyword不能同时为空）
        if(categoryId == null && keyword == null){
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、判断categoryId
        Set<Integer> integerSet = Sets.newHashSet();
        if(categoryId != null){
            Category category = categoryMapper.selectByPrimaryKey(categoryId);
            if(category == null && (category == null || keyword.equals(""))){
                //没有此商品数据
                PageHelper.startPage(pageNum,pageSize);
                List<ProductListVo> productListVos = Lists.newArrayList();
                PageInfo pageInfo = new PageInfo(productListVos);
                return ServerResponse.serverResponseBySuccess(pageInfo);
            }
            //递归查询
            ServerResponse serverResponse = iCategoryService.getDeepCategory(categoryId);

            if (serverResponse.isSuccess()){
                integerSet = (Set<Integer>) serverResponse.getData();
            }
        }
        // 3、判断keyword
        if (keyword != null && !keyword.equals("")){
            keyword = "%" + keyword + "%";
        }
        // 4、判断orderBy（排序规则）
        if (orderBy.equals("")){
            PageHelper.startPage(pageNum,pageSize);
        }else {
            String[] orderByArr = orderBy.split("_");
            if(orderByArr.length > 1){
                PageHelper.startPage(pageNum,pageSize,orderByArr[0] + " " + orderByArr[1]);
            }else {
                PageHelper.startPage(pageNum,pageSize);
            }
        }
        // 4、List<Product> -> List<ProductVo>
        List<Product> products = productMapper.searchProduct(integerSet, keyword, orderBy);
        List<ProductListVo> productListVos = Lists.newArrayList();
        if (products != null && products.size() > 0){
            for (Product product : products) {
                ProductListVo productListVo = toProductListVo(product);
                productListVos.add(productListVo);
            }
        }

        // 3、分页
        PageInfo pageInfo = new PageInfo();
        pageInfo.setList(productListVos);
        // 4、返回结果
        return ServerResponse.serverResponseBySuccess(pageInfo);
    }

    /**
     * product转成productListVo方法
     */
    private ProductListVo toProductListVo(Product product){

        ProductListVo productListVo = new ProductListVo();
        productListVo.setId(product.getId());
        productListVo.setCategoryId(product.getCategoryId());
        productListVo.setMainImage(product.getMainImage());
        productListVo.setName(product.getName());
        productListVo.setPrice(product.getPrice());
        productListVo.setStatus(product.getStatus());
        productListVo.setSubtitle(product.getSubtitle());

        return productListVo;
    }

    /**
     * product转成productDetailVo方法
     */
    private ProductDetailVo toProductDetailVo(Product product) {

        ProductDetailVo productDetailVo = new ProductDetailVo();
        productDetailVo.setId(product.getId());
        productDetailVo.setCategoryId(product.getCategoryId());
        productDetailVo.setCreateTime(DateUtils.dateToStr(product.getCreateTime()));
        productDetailVo.setUpdateTime(DateUtils.dateToStr(product.getUpdateTime()));
        productDetailVo.setDetail(product.getDetail());
        productDetailVo.setImageHost(PropertiesUtils.readByKey("imageHost"));
        productDetailVo.setName(product.getName());
        productDetailVo.setMainImage(product.getMainImage());
        productDetailVo.setPrice(product.getPrice());
        productDetailVo.setStatus(product.getStatus());
        productDetailVo.setStock(product.getStock());
        productDetailVo.setSubImages(product.getSubImages());
        productDetailVo.setSubtitle(product.getSubtitle());

        Category category = categoryMapper.selectByPrimaryKey(product.getCategoryId());
        if(category != null){
            productDetailVo.setParentCategoryId(category.getParentId());
        }else{
            productDetailVo.setParentCategoryId(0);
        }
        return productDetailVo;
    }
}
