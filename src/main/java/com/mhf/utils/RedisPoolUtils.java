package com.mhf.utils;

import com.mhf.common.RedisPool;
import redis.clients.jedis.Jedis;

public class RedisPoolUtils {

    /**
     * 添加key、value
     *
     * @param key
     * @param value
     * @return
     */
    public static String set(String key, String value) {
        Jedis jedis = null;
        String result = null;
        try {
            jedis = RedisPool.getJedis();
            result = jedis.set(key, value);
        } catch (Exception e) {
            e.printStackTrace();
            RedisPool.returnBrokenResource(jedis);
        } finally {
            RedisPool.returnResource(jedis);
        }

        return result;
    }

    /**
     * 添加key、过期时间、value
     *
     * @param key
     * @param value
     * @param expireTime
     * @return
     */
    public static String setex(String key, String value, int expireTime) {
        Jedis jedis = null;
        String result = null;
        try {
            jedis = RedisPool.getJedis();
            result = jedis.setex(key, expireTime, value);
        } catch (Exception e) {
            e.printStackTrace();
            RedisPool.returnBrokenResource(jedis);
        } finally {
            RedisPool.returnResource(jedis);
        }

        return result;
    }

    /**
     * 根据key获取value3
     *
     * @param key
     * @return
     */
    public static String get(String key) {
        Jedis jedis = null;
        String result = null;
        try {
            jedis = RedisPool.getJedis();
            result = jedis.get(key);
        } catch (Exception e) {
            e.printStackTrace();
            RedisPool.returnBrokenResource(jedis);
        } finally {
            RedisPool.returnResource(jedis);
        }

        return result;
    }

    /**
     * 根据key删除
     *
     * @param key
     * @return
     */
    public static Long delete(String key) {
        Jedis jedis = null;
        Long result = null;
        try {
            jedis = RedisPool.getJedis();
            result = jedis.del(key);
        } catch (Exception e) {
            e.printStackTrace();
            RedisPool.returnBrokenResource(jedis);
        } finally {
            RedisPool.returnResource(jedis);
        }

        return result;
    }

    /**
     * 设置key有效时间
     *
     * @param key
     * @return
     */
    public static Long expire(String key, int expireTime) {
        Jedis jedis = null;
        Long result = null;
        try {
            jedis = RedisPool.getJedis();
            result = jedis.expire(key, expireTime);
        } catch (Exception e) {
            e.printStackTrace();
            RedisPool.returnBrokenResource(jedis);
        } finally {
            RedisPool.returnResource(jedis);
        }

        return result;
    }
}
