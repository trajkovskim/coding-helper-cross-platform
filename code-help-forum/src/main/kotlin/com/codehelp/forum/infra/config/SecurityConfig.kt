package com.codehelp.forum.infra.config

import com.codehelp.forum.infra.AuthProperties
import com.codehelp.forum.infra.filter.AuthenticationFilter
import com.codehelp.forum.infra.filter.AuthorizationFilter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy.STATELESS
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter


@Configuration
@EnableWebSecurity
class SecurityConfig(private val authProperties: AuthProperties) {


    @Bean
    fun filterChain(
        http: HttpSecurity,
        authenticationFilter: AuthenticationFilter,
        authorizationFilter: AuthorizationFilter
    ): SecurityFilterChain {
        return http.authorizeHttpRequests()
            .requestMatchers(authProperties.login.path, authProperties.refresh.path).permitAll()
            .anyRequest().fullyAuthenticated()
            .and().sessionManagement().sessionCreationPolicy(STATELESS)
            .and().csrf().disable()
            .addFilter(authenticationFilter)
            .addFilterBefore(authorizationFilter, UsernamePasswordAuthenticationFilter::class.java)
            .build()
    }


    @Bean
    fun passwordEncoder(): PasswordEncoder = BCryptPasswordEncoder()


    @Bean
    fun authenticationManager(authenticationConfiguration: AuthenticationConfiguration): AuthenticationManager =
        authenticationConfiguration.authenticationManager

}
