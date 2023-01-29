package com.codehelp.forum.infra.filter

import com.codehelp.forum.generated.rest.model.UserCredentialsDto
import com.codehelp.forum.infra.AuthProperties
import com.codehelp.forum.service.impl.AuthService
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.User
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import org.springframework.stereotype.Component

@Component
class AuthenticationFilter(
    private val authenticationManager: AuthenticationManager,
    private val authProperties: AuthProperties,
    private val authService: AuthService,
) : UsernamePasswordAuthenticationFilter(authenticationManager) {

    init {
        this.setFilterProcessesUrl(authProperties.login.path)
    }


    override fun attemptAuthentication(request: HttpServletRequest, response: HttpServletResponse): Authentication {
        val credentials = request.getRequestBody(UserCredentialsDto::class.java).toApplicationModel()

        val authenticationToken = UsernamePasswordAuthenticationToken(credentials.username, credentials.password)

        return authenticationManager.authenticate(authenticationToken)
    }

    override fun successfulAuthentication(
        request: HttpServletRequest,
        response: HttpServletResponse,
        chain: FilterChain,
        authResult: Authentication
    ) {
        val user: User = authResult.principal as User
        val tokens = authService.generateToken(user, request)

        response.setAuthHeaders(tokens)
        response.setResponseBody(tokens.toDto())
    }
}


