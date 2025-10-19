package com.noteflow.backend.config;

import com.noteflow.backend.filter.JWTAuthenticationTokenFilter;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

/**
 * Security 配置类
 */
@Slf4j
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Resource
    private JWTAuthenticationTokenFilter jwtAuthenticationTokenFilter;

    @Value("${cors.allowedOrigins}")
    private String corsAllowedOrigins;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // 禁用 CSRF 保护
        http.csrf(AbstractHttpConfigurer::disable);

        // 授权请求配置
        http.authorizeHttpRequests(auth -> {
            auth.requestMatchers("/**").permitAll()
                    .anyRequest().authenticated();
        });

        // 登出配置
        http.logout(logout -> logout.logoutUrl("/user/logout"));

        // 跨域配置
        http.cors(cors -> cors.configurationSource(corsConfigurationSource()));

        // 过滤器配置
        http.addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.addAllowedOrigin(corsAllowedOrigins);
        configuration.addAllowedMethod("*");
        configuration.addAllowedHeader("*");
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}