package com.codehelp.forum.service.impl

import com.codehelp.forum.infra.filter.AuthResponse
import com.codehelp.forum.infra.filter.toSpringUser
import com.codehelp.forum.infra.util.JwtUtils
import com.codehelp.forum.service.UserService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class AuthService(
    private val userService: UserService,
    private val jwtUtils: JwtUtils
) {

    fun generateToken(user: User, request: HttpServletRequest): AuthResponse {
        return generate(user, request);
    }

    fun refreshToken(authorizationHeader: String, request: HttpServletRequest): AuthResponse {
        val decodedJWT = jwtUtils.decodeToken(authorizationHeader)
        val username = decodedJWT.subject;

        val user = userService.getUser(username)?.toSpringUser()
            ?: throw UsernameNotFoundException("Could not find username")

        val refreshToken = jwtUtils.removeTokenPrefix(authorizationHeader)

        return generate(user, request, refreshToken)
    }

    private fun generate(user: User, request: HttpServletRequest, refreshTokenHeader: String? = null): AuthResponse {
        val username = user.username
        val issuer = request.requestURL.toString()
        val roles = user.authorities.stream().map(GrantedAuthority::getAuthority).toList()

        val accessToken: String = jwtUtils.createAccessToken(username, issuer, roles)
        val refreshToken = refreshTokenHeader ?: jwtUtils.createRefreshToken(username, issuer)

        return jwtUtils.createResponse(accessToken, refreshToken)
    }
}