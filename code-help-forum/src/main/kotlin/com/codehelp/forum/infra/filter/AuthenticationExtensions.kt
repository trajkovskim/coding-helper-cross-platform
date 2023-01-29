package com.codehelp.forum.infra.filter

import com.codehelp.forum.domain.User
import com.codehelp.forum.generated.rest.model.AuthResponseDto
import com.codehelp.forum.generated.rest.model.UserCredentialsDto
import com.fasterxml.jackson.databind.ObjectMapper
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.security.core.userdetails.User as SpringUser


private const val ACCESS_TOKEN_HEADER = "access_token"
private const val REFRESH_TOKEN_HEADER = "refresh_token"

fun <T> HttpServletRequest.getRequestBody(type: Class<T>): T =
    ObjectMapper().readValue(this.reader, type)


fun ResponseEntity.BodyBuilder.authHeaders(tokens: AuthResponse) =
    this.authHeaders(tokens.accessToken, tokens.refreshToken)


fun ResponseEntity.BodyBuilder.authHeaders(accessToken: String, refreshToken: String) =
    this.header(ACCESS_TOKEN_HEADER, accessToken)
        .header(REFRESH_TOKEN_HEADER, refreshToken)


fun HttpServletResponse.setAuthHeaders(tokens: AuthResponse) {
    this.setAuthHeaders(tokens.accessToken, tokens.refreshToken)
}

fun HttpServletResponse.setAuthHeaders(accessToken: String, refreshToken: String) {
    this.setHeader(ACCESS_TOKEN_HEADER, accessToken)
    this.setHeader(REFRESH_TOKEN_HEADER, refreshToken)
}

fun <T> HttpServletResponse.setResponseBody(responseObject: T) {
    this.contentType = MediaType.APPLICATION_JSON.toString()
    ObjectMapper().writeValue(this.outputStream, responseObject)
}

fun UserCredentialsDto.toApplicationModel() =
    UserCredentials(this.username, this.password)

fun User.toSpringUser(): SpringUser =
    SpringUser(this.username, this.password, listOf())


fun AuthResponse.toDto(): AuthResponseDto =
    AuthResponseDto()
        .accessToken(accessToken)
        .refreshToken(refreshToken)

data class UserCredentials(val username: String, val password: String)
data class AuthResponse(val accessToken: String, val refreshToken: String)
