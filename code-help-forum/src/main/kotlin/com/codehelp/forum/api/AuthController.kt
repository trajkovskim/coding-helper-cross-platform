package com.codehelp.forum.api

import com.codehelp.forum.generated.rest.api.AuthApi
import com.codehelp.forum.generated.rest.model.AuthResponseDto
import com.codehelp.forum.generated.rest.model.UserCreateDto
import com.codehelp.forum.generated.rest.model.UserCredentialsDto
import com.codehelp.forum.infra.filter.authHeaders
import com.codehelp.forum.infra.filter.toDto
import com.codehelp.forum.service.UserService
import com.codehelp.forum.service.impl.AuthService
import jakarta.servlet.http.HttpServletRequest
import org.springframework.http.HttpHeaders
import org.springframework.http.ResponseEntity

@RestControllerAuth
class AuthController(
    private val authService: AuthService,
    private val userService: UserService,
    private val httpServletRequest: HttpServletRequest,
) : AuthApi {


    override fun login(userCredentials: UserCredentialsDto?): ResponseEntity<AuthResponseDto> {
        TODO("Not yet implemented")
    }

    override fun refresh(authorization: String?): ResponseEntity<AuthResponseDto> {
        val authorizationHeader: String = httpServletRequest.getHeader(HttpHeaders.AUTHORIZATION)

        try {
            val tokens = authService.refreshToken(authorizationHeader, httpServletRequest)

            return ResponseEntity.ok().authHeaders(tokens).body(tokens.toDto())

        } catch (exception: Exception) {
            throw RuntimeException("Forbidden", exception)
        }
    }

    override fun register(userCreate: UserCreateDto): ResponseEntity<Void> {
        userService.registerUser(userCreate)

        return ResponseEntity.ok().build()
    }

}
