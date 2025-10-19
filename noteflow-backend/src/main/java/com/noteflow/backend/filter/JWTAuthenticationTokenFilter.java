package com.noteflow.backend.filter;

import com.alibaba.fastjson2.JSONObject;
import com.noteflow.backend.entity.bean.RestBean;
import com.noteflow.backend.utils.JWTUtil;
import com.noteflow.backend.utils.RedisCache;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.micrometer.common.util.StringUtils;
import jakarta.annotation.Resource;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Objects;

/**
 * JWT TOKEN 过滤器
 */
@Component
public class JWTAuthenticationTokenFilter extends OncePerRequestFilter {
    @Resource
    private RedisCache redisCache;

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";
    private static final String LOGIN_PREFIX = "login:";
    private static final String UTF_8 = "UTF-8";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        response.setCharacterEncoding(UTF_8);
        // 获取 Token
        String token = request.getHeader(AUTHORIZATION_HEADER);
        if (io.micrometer.common.util.StringUtils.isNotEmpty(token) && token.startsWith(BEARER_PREFIX)) {
            token = token.replace(BEARER_PREFIX, "");
        }
        if (StringUtils.isEmpty(token)) {
            filterChain.doFilter(request, response);
            return;
        }
        String userId;
        try {
            Claims claims = JWTUtil.parseJWT(token);
            userId = claims.getSubject();
        } catch (ExpiredJwtException e) {
            // token已过期，返回特定的错误码
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(JSONObject.toJSONString(RestBean.error(4011, "token已过期，请刷新")));
            return;
        } catch (Exception e) {
            // token非法（格式错误、签名无效等）
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(JSONObject.toJSONString(RestBean.error(4012, "token无效，请重新登录")));
            return;
        }

        String redisKey = LOGIN_PREFIX + userId;
        Objects loginUser = redisCache.getCacheObject(redisKey);
        if (Objects.isNull(loginUser)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(JSONObject.toJSONString(RestBean.error(4013, "登录状态已失效，请重新登录")));
            return;
        }

        // 创建认证信息并设置到上下文中
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(userId, null, new ArrayList<>());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        filterChain.doFilter(request, response);
    }

}