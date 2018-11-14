package com.mhf.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 购物车实体类
 */
public class CartVo implements Serializable {
    //购物信息集合
    private List<CartProductVo> cartProductVos;
    //是否全选
    private boolean isAllChecked;
    //总价格
    private BigDecimal cartTotalPrice;

    public List<CartProductVo> getCartProductVos() {
        return cartProductVos;
    }

    public void setCartProductVos(List<CartProductVo> cartProductVos) {
        this.cartProductVos = cartProductVos;
    }

    public boolean isAllChecked() {
        return isAllChecked;
    }

    public void setAllChecked(boolean allChecked) {
        isAllChecked = allChecked;
    }

    public BigDecimal getCartTotalPrice() {
        return cartTotalPrice;
    }

    public void setCartTotalPrice(BigDecimal cartTotalPrice) {
        this.cartTotalPrice = cartTotalPrice;
    }
}
