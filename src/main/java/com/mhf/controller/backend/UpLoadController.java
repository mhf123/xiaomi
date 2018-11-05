package com.mhf.controller.backend;

import com.mhf.common.ServerResponse;
import com.mhf.pojo.Product;
import com.mhf.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping(value = "/manager1/product")
public class UpLoadController {
    @Autowired
    IProductService iProductService;

    @RequestMapping(value = "/upload",method = RequestMethod.GET)
    public String upload(){
        return "upload";//逻辑视图
    }
    @RequestMapping(value = "/upload",method = RequestMethod.POST)
    @ResponseBody
    public ServerResponse upload1(@RequestParam(value = "upload_file",required = false) MultipartFile file){
        String path = "C:/Users/14338/Desktop/picture/";
        return iProductService.upload(file,path);
    }
}
