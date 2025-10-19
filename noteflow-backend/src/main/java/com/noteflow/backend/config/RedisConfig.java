package com.noteflow.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/**
 * Redis 配置
 */
@Configuration
public class RedisConfig {

    @Bean
    public FastJson2RedisSerializer<Object> fastJson2RedisSerializer() {
        // serializer.addAccept("com.noteflow.backend.**"); // 加白名单
        return new FastJson2RedisSerializer<>(Object.class);
    }

    @Bean
    public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory connectionFactory,
                                                       FastJson2RedisSerializer<Object> fastJson2RedisSerializer) {
        RedisTemplate<Object, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(fastJson2RedisSerializer);

        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(fastJson2RedisSerializer);

        template.afterPropertiesSet();
        return template;
    }
}