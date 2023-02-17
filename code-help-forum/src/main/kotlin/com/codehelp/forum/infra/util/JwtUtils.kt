package com.codehelp.forum.infra.util

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.DecodedJWT
import com.codehelp.forum.infra.AuthProperties
import com.codehelp.forum.infra.MILLISECONDS
import com.codehelp.forum.infra.SECONDS
import com.codehelp.forum.infra.filter.AuthResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.stereotype.Component
import java.time.Instant

@Component
class
JwtUtils(private val authProperties: AuthProperties) {

    private val accessTokenTimeout = authProperties.token.access.timeout * SECONDS * MILLISECONDS
    private val refreshTokenTimeout = authProperties.token.refresh.timeout * SECONDS * MILLISECONDS

    private val algorithm: Algorithm = Algorithm.HMAC256(authProperties.token.secret)

    fun decodeToken(authorizationHeader: String?): DecodedJWT {
        if (authorizationHeader == null || !authorizationHeader.startsWith(authProperties.token.prefix)) {
            throw RuntimeException("Authorization header is invalid")
        }

        val token = removeTokenPrefix(authorizationHeader)

        val verifier = JWT.require(algorithm).build()
        return verifier.verify(token)
    }

    fun createAccessToken(username: String, issuer: String, authorities: List<String>): String = JWT.create()
        .withSubject(username)
        .withIssuedAt(Instant.now())
        .withExpiresAt(Instant.now().plusMillis(accessTokenTimeout))
        .withIssuer(issuer)
        .withClaim("roles", authorities)
        .sign(algorithm)

    fun createRefreshToken(username: String, issuer: String): String = JWT.create()
        .withSubject(username)
        .withIssuedAt(Instant.now())
        .withExpiresAt(Instant.now().plusMillis(refreshTokenTimeout))
        .withIssuer(issuer)
        .sign(algorithm)

    fun createAuthenticationToken(authorizationHeader: String): UsernamePasswordAuthenticationToken {
        val decodedToken = decodeToken(authorizationHeader)

        val username = decodedToken.subject;
        val roles = decodedToken.getClaim("roles").asList(String::class.java).stream()
            .map(::SimpleGrantedAuthority)
            .toList()

        return UsernamePasswordAuthenticationToken(username, null, roles)
    }

    fun createResponse(accessToken: String, refreshToken: String): AuthResponse {
        return AuthResponse(accessToken, refreshToken)
    }

    fun createErrorResponse(errorMessage: String): Map<String, String> {
        return mapOf(
            Pair("errorMessage", errorMessage)
        )
    }

    fun removeTokenPrefix(token: String) = token.substring(authProperties.token.prefix.length)

}


