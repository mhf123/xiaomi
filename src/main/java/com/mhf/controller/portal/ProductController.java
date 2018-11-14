package com.mhf.controller.portal;

import com.mhf.common.ServerResponse;
import com.mhf.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/product")
public class ProductController {
    @Autowired
    IProductService iProductService;
    /**
     * 商品详情
     */
    @RequestMapping(value = "detail/{productId}")
    public ServerResponse detail(@PathVariable("productId")Integer productId){
        ServerResponse serverResponse = iProductService.detailPortal(productId);
        return serverResponse;
    }

    /**
     * 商品搜索
     */
    @RequestMapping(value = "list")
    public ServerResponse list(@RequestParam(required = false) Integer categoryId,
                               @RequestParam(required = false) String keyword,
                               @RequestParam(required = false,defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false,defaultValue = "10") Integer pageSize,
                               @RequestParam(required = false,defaultValue = "") String orderBy){
        ServerResponse serverResponse = iProductService.listPortal(categoryId,keyword,pageNum,pageSize,orderBy);
        return serverResponse;
    }
}
