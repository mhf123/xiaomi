package com.mhf.service.impl;

import com.google.common.collect.Lists;
import com.mhf.common.Const;
import com.mhf.common.ServerResponse;
import com.mhf.dao.CartMapper;
import com.mhf.dao.ProductMapper;
import com.mhf.pojo.Cart;
import com.mhf.pojo.Product;
import com.mhf.pojo.User;
import com.mhf.service.ICartService;
import com.mhf.utils.BigDecimalUtils;
import com.mhf.vo.CartProductVo;
import com.mhf.vo.CartVo;
import com.sun.org.apache.xpath.internal.operations.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

@Service
public class CartServiceImpl implements ICartService {
    @Autowired
    CartMapper cartMapper;
    @Autowired
    ProductMapper productMapper;

    @Transactional
    @Override
    public ServerResponse add(Integer userId, Integer productId, Integer count) {

        // 1、参数非空校验
        if (userId == null || productId == null || count == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }

        //判断是否存在商品
        Product product = productMapper.selectByPrimaryKey(productId);
        if (product == null) {
            return ServerResponse.serverResponseByError("商品不存在");
        }
        //判断商品状态
        if (product.getStatus() != Const.ProductStatusEnum.PRODUCT_ONLINE.getCode()) {
            return ServerResponse.serverResponseByError("商品已下架");
        }
        //判断商品库存
        if (product.getStock() < count) {
            return ServerResponse.serverResponseByError("商品库存不足");
        }
        // 2、通过productId、userId查询购物信息
        Cart cart = cartMapper.selectCartByUserIdAndProductId(userId, productId);
        if (cart == null) {
            //添加
            Cart cart1 = new Cart();
            cart1.setUserId(userId);
            cart1.setProductId(productId);
            cart1.setQuantity(count);
            cart1.setChecked(Const.CartCheckedEnum.PRODUCT_CHECKED.getCode());
            cartMapper.insert(cart1);
        } else {
            //更新
            Cart cart1 = new Cart();
            cart1.setId(cart.getId());
            cart1.setProductId(productId);
            cart1.setQuantity(count + cart.getQuantity());
            cart1.setChecked(Const.CartCheckedEnum.PRODUCT_CHECKED.getCode());
            cartMapper.updateByPrimaryKey(cart1);
        }
        CartVo cartVoLimit = getCartVoLimit(userId);

        return ServerResponse.serverResponseBySuccess(cartVoLimit);
    }


    @Override
    public ServerResponse list(Integer userId) {
        CartVo cartVoLimit = getCartVoLimit(userId);
        return ServerResponse.serverResponseBySuccess(cartVoLimit);
    }

    @Transactional
    @Override
    public ServerResponse update(Integer userId, Integer productId, Integer count) {
        // 1、参数校验
        if (productId == null || count == null) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、查询购物车商品
        Cart cart = cartMapper.selectCartByUserIdAndProductId(userId, productId);
        // 3、更新数量
        if (cart != null) {
            cart.setQuantity(count);
            cartMapper.updateByPrimaryKey(cart);
        }
        // 4、返回结果
        CartVo cartVoLimit = getCartVoLimit(userId);
        return ServerResponse.serverResponseBySuccess(cartVoLimit);
    }

    @Transactional
    @Override
    public ServerResponse deleteProduct(Integer userId, String productIds) {
        // 1、参数非空校验
        if (productIds == null || productIds.equals("")) {
            return ServerResponse.serverResponseByError("参数不能为空");
        }
        // 2、productIds -> List<Integer>
        List<Integer> productIdList = Lists.newArrayList();
        String[] productIdArr = productIds.split(",");
        if (productIdArr.length > 0 && productIdArr != null) {
            for (String s : productIdArr) {
                Integer productId = Integer.parseInt(s);
                productIdList.add(productId);
            }
        }
        // 3、删除
        cartMapper.deleteByUserIdAndProductId(userId, productIdList);
        // 4、返回结果
        CartVo cartVoLimit = getCartVoLimit(userId);
        return ServerResponse.serverResponseBySuccess(cartVoLimit);
    }

    @Override
    public ServerResponse select(Integer userId, Integer productId, Integer check) {
        // 1、参数非空校验
//        if (productId == null) {
//            return ServerResponse.serverResponseByError("参数不能为空");
//        }
        // 2、选中
        cartMapper.selectOrUnselectProduct(userId, productId, check);
        // 3、返回结果
        CartVo cartVoLimit = getCartVoLimit(userId);
        return ServerResponse.serverResponseBySuccess(cartVoLimit);
    }

    @Override
    public ServerResponse getCartProductCount(Integer userId) {
        int cartProductCount = cartMapper.getCartProductCount(userId);
        return ServerResponse.serverResponseBySuccess(cartProductCount);
    }

    private CartVo getCartVoLimit(Integer userId) {
        CartVo cartVo = new CartVo();
        // 1、根据userId查询购物信息
        List<Cart> carts = cartMapper.selectCartByUserId(userId);

        // 2、 List<Cart> -> List<CartProductVo>
        List<CartProductVo> cartProductVolist = Lists.newArrayList();
        //购物车总价格
        BigDecimal cartTotalPrice = new BigDecimal("0");

        if (carts != null && carts.size() > 0) {
            for (Cart cart : carts) {
                CartProductVo cartProductVo = new CartProductVo();
                cartProductVo.setId(cart.getId());
                cartProductVo.setQuantity(cart.getQuantity());
                cartProductVo.setUserId(userId);
                cartProductVo.setProductChecked(cart.getChecked());
                //查询商品
                Product product = productMapper.selectByPrimaryKey(cart.getProductId());
                if (product != null) {
                    cartProductVo.setProductId(cart.getProductId());
                    cartProductVo.setProductMainImage(product.getMainImage());
                    cartProductVo.setProductName(product.getName());
                    cartProductVo.setProductPrice(product.getPrice());
                    cartProductVo.setProductStatus(product.getStatus());
                    cartProductVo.setProductStock(product.getStock());
                    cartProductVo.setProductSubtitle(product.getSubtitle());
                    cartProductVo.setProductDetail(product.getDetail());
                    cartProductVo.setProductColor(product.getColor2());

                    //设置商品数量
                    int stock = product.getStock();
                    int limitCount = 0;
                    if (stock >= cart.getQuantity()) {
                        //库存充足
                        limitCount = cart.getQuantity();
                        cartProductVo.setLimitQuantity("LIMIT_NUM_SUCCESS");
                    } else {
                        //库存不足
                        limitCount = stock;
                        //更新购物车商品数量
                        Cart cart1 = new Cart();
                        cart1.setId(cart.getId());
                        cart1.setQuantity(stock);
                        cart1.setProductId(cart.getProductId());
                        cart1.setChecked(cart.getChecked());
                        cart1.setUserId(userId);
                        cartMapper.updateByPrimaryKey(cart1);

                        cartProductVo.setLimitQuantity("LIMIT_NUM_FAIL");
                    }
                    cartProductVo.setQuantity(limitCount);
                    cartProductVo.setProductTotalPrice(BigDecimalUtils.mul(product.getPrice().doubleValue(), Double.valueOf(cartProductVo.getQuantity())));
                }
                //总价格求和
                if (cartProductVo.getProductChecked() == Const.CartCheckedEnum.PRODUCT_CHECKED.getCode()) {
                    cartTotalPrice = BigDecimalUtils.add(cartTotalPrice.doubleValue(), cartProductVo.getProductTotalPrice().doubleValue());
                }

                cartProductVolist.add(cartProductVo);
            }
        }

        cartVo.setCartProductVos(cartProductVolist);
        // 3、计算总价格
        cartVo.setCartTotalPrice(cartTotalPrice);
        // 4、判断购物车是否全选
        int count = cartMapper.isCheckedAll(userId);
        int count1 = cartMapper.getCartProductCount(userId);
        if (count > 0 || count1 == 0) {
            cartVo.setAllChecked(false);
        } else {
            cartVo.setAllChecked(true);
        }
        // 5、返回结果
        return cartVo;
    }
}
