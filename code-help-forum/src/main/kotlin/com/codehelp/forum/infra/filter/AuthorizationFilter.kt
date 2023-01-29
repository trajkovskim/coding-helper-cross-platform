package com.codehelp.forum.infra.filter

import com.codehelp.forum.infra.AuthProperties
import com.codehelp.forum.infra.util.JwtUtils
import io.netty.handler.codec.http.HttpResponseStatus.FORBIDDEN
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.HttpHeaders
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

@Component
class AuthorizationFilter(
    private val authProperties: AuthProperties,
    private val jwtUtils: JwtUtils
) : OncePerRequestFilter() {

    private val tokenPrefix = authProperties.token.prefix
    private val excludedPaths = listOf(authProperties.login.path, authProperties.refresh.path)

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        if (excludedPaths.contains(request.servletPath)) {
            return filterChain.doFilter(request, response)
        }

        val authorizationHeader: String? = request.getHeader(HttpHeaders.AUTHORIZATION)

        if (authorizationHeader == null || !authorizationHeader.startsWith(tokenPrefix)) {
            return filterChain.doFilter(request, response)
        }

        try {
            SecurityContextHolder.getContext().authentication = jwtUtils.createAuthenticationToken(authorizationHeader)
        } catch (exception: Exception) {
            response.setHeader("error", exception.message)
            val error = exception.message?.let { jwtUtils.createErrorResponse(it) }

            response.status = FORBIDDEN.code()
            response.setResponseBody(error)
        }

        filterChain.doFilter(request, response)
    }
}