package com.mhf.controller.backend;

import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.pojo.Product;
import com.mhf.pojo.User;
import com.mhf.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping(value = "/manager1/product")
public class ProductManagerController {

    @Autowired
    IProductService iProductService;

    /**
     * 新增OR更新商品
     */
    @RequestMapping(value = "/saveOrUpdate")
    public ServerResponse saveOrUpdate(Product product) {

        ServerResponse serverResponse = iProductService.saveOrUpdate(product);
        return serverResponse;
    }

    /**
     * 产品上下架
     */
    @RequestMapping(value = "/setSaleStatus/{productId}/{status}")
    public ServerResponse setSaleStatus(@PathVariable("productId") Integer productId,
                                        @PathVariable("status") Integer status) {

        ServerResponse serverResponse = iProductService.setSaleStatus(productId, status);
        return serverResponse;
    }

    /**
     * 商品详情
     */
    @RequestMapping(value = "/detail/{productId}")
    public ServerResponse detail(@PathVariable("productId") Integer productId) {

        ServerResponse serverResponse = iProductService.detail(productId);
        return serverResponse;
    }

    /**
     * 查询商品列表
     */
    @RequestMapping(value = "/list")
    public ServerResponse detail(@RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize", required = false, defaultValue = "10") Integer pageSize) {

        ServerResponse serverResponse = iProductService.list(pageNum, pageSize);
        return serverResponse;
    }

    /**
     * 产品搜索
     */
    @RequestMapping(value = "/search")
    public ServerResponse search(@RequestParam(value = "productId", required = false) Integer productId,
                                 @RequestParam(value = "productName", required = false) String productName,
                                 @RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize", required = false, defaultValue = "10") Integer pageSize) {

        ServerResponse serverResponse = iProductService.search(productId, productName, pageNum, pageSize);
        return serverResponse;
    }

    /**
     * 图片上传
     */
    @RequestMapping(value = "/upload.do")
    public ServerResponse upload(@RequestParam(value = "productId", required = false) Integer productId,
                                 @RequestParam(value = "productName", required = false) String productName,
                                 @RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                                 @RequestParam(value = "pageSize", required = false, defaultValue = "10") Integer pageSize) {

        ServerResponse serverResponse = iProductService.search(productId, productName, pageNum, pageSize);
        return serverResponse;
    }
}
