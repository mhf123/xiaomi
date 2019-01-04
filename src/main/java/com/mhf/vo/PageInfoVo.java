package com.mhf.vo;

import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * 分页Vo工具类
 */
public class PageInfoVo {
    public PageInfo pageInfo;
    public List list;

    public PageInfoVo(PageInfo pageInfo, List list) {
        this.pageInfo = pageInfo;
        this.list = list;
    }

    public PageInfo getPageInfo() {
        return pageInfo;
    }

    public void setPageInfo(PageInfo pageInfo) {
        this.pageInfo = pageInfo;
    }

    public List getList() {
        return list;
    }

    public void setList(List list) {
        this.list = list;
    }
}
