package com.codehelp.forum.infra.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy.STATELESS
import org.springframework.security.web.SecurityFilterChain

@Configuration
@EnableWebSecurity
class SecurityConfig {

    @Bean
    fun filterChain(http: HttpSecurity): SecurityFilterChain {
        return http.authorizeHttpRequests()
            .anyRequest().fullyAuthenticated()
            .and().sessionManagement().sessionCreationPolicy(STATELESS)
            .and().csrf().disable()
            .build()
    }
}
