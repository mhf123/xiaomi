package com.mhf.common;

import com.mhf.utils.PropertiesUtils;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisPool {

    private static JedisPool jedisPool;
    //最大连接数
    private static Integer maxTotal = Integer.parseInt(PropertiesUtils.readByKey("redis.max.total"));
    //最大空闲数
    private static Integer maxIdle = Integer.parseInt(PropertiesUtils.readByKey("redis.max.idle"));
    //最小空闲数
    private static Integer minIdle = Integer.parseInt(PropertiesUtils.readByKey("redis.min.idle"));

    //判断是否为有效实例
    private static boolean testBorrow = Boolean.valueOf(PropertiesUtils.readByKey("redis.test.borrow"));
    private static boolean testReturn = Boolean.valueOf(PropertiesUtils.readByKey("redis.test.return"));

    //ip
    private static String redisIp = PropertiesUtils.readByKey("redis.ip");
    //port
    private static Integer redisPort = Integer.parseInt(PropertiesUtils.readByKey("redis.port"));
    //password
    private static String password = PropertiesUtils.readByKey("redis.password");

    private static void initPool(){
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxIdle(maxIdle);
        config.setMaxTotal(maxTotal);
        config.setMinIdle(minIdle);

        config.setTestOnBorrow(testBorrow);
        config.setTestOnReturn(testReturn);
        //在连接耗尽时，判断是否阻塞，false:抛出异常，true：等待连接直到超时（默认）
        config.setBlockWhenExhausted(true);

        jedisPool = new JedisPool(config,redisIp,redisPort,1000*2,password);
    }

    static {
        initPool();
    }

    public static Jedis getJedis(){
        return jedisPool.getResource();
    }
    public static void returnResource(Jedis jedis){
        jedisPool.returnResource(jedis);
    }
    public static void returnBrokenResource(Jedis jedis){
        jedisPool.returnBrokenResource(jedis);
    }

}