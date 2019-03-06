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
                               @RequestParam(required = false,defaultValue = "28") Integer pageSize,
                               @RequestParam(required = false,defaultValue = "") String orderBy){
        ServerResponse serverResponse = iProductService.listPortal(categoryId,keyword,pageNum,pageSize,orderBy);
        return serverResponse;
    }

    /**
     * 商品搜索提示
     */
    @RequestMapping(value = "suggestList/{keyword}")
    public ServerResponse list(@PathVariable("keyword")String keyword,
                               @RequestParam(required = false,defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false,defaultValue = "10") Integer pageSize,
                               @RequestParam(required = false,defaultValue = "") String orderBy){
        ServerResponse serverResponse = iProductService.suggestList(keyword,pageNum,pageSize,orderBy);
        return serverResponse;
    }

    /**
     * 根据分类查找商品名称列表
     */
    @RequestMapping(value = "nameList/{categoryId}")
    public ServerResponse list(@PathVariable("categoryId")Integer categoryId,
                               @RequestParam(required = false,defaultValue = "1") Integer pageNum,
                               @RequestParam(required = false,defaultValue = "10") Integer pageSize,
                               @RequestParam(required = false,defaultValue = "") String orderBy){
        ServerResponse serverResponse = iProductService.nameList(categoryId,pageNum,pageSize,orderBy);
        return serverResponse;
    }

    /**
     * 按需查询商品列表
     */
    @RequestMapping(value = "listByDemand/{productName:.+}")
    public ServerResponse listByDemand(@PathVariable("productName") String productName,
                                       @RequestParam(required = false) String detail,
                                       @RequestParam(required = false) String color){
        ServerResponse serverResponse = iProductService.listByDemand(productName,detail,color);
        return serverResponse;
    }
}
