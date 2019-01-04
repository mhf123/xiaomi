package com.mhf.controller.backend;

import com.google.common.collect.Lists;
import com.mhf.common.ServerResponse;
import com.mhf.service.IProductService;
import com.mhf.utils.PropertiesUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/manager1/product")
public class UpLoadController {
    @Autowired
    IProductService iProductService;

    @RequestMapping(value = "/upload", method = RequestMethod.GET)
    public String upload() {
        return "upload";//逻辑视图
    }

    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    @ResponseBody
    public ServerResponse upload1(@RequestParam(value = "upload_file", required = false) MultipartFile[] fileArray) {
        String path = PropertiesUtils.readByKey("imagePath");
        List<Map<String,String>> mapList = Lists.newArrayList();
        for (MultipartFile file : fileArray) {
            // 1、非空校验
            if (file == null) {
                return ServerResponse.serverResponseByError("参数为空");
            }
            Map<String,String> map;
            // 2、批量上传文件,获取集合
            map = iProductService.upload(file, path);
            mapList.add(map);
        }
        return ServerResponse.serverResponseBySuccess(mapList);
    }


}
