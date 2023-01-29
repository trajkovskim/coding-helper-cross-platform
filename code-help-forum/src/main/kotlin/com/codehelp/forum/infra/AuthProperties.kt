package com.codehelp.forum.infra

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Configuration

@Configuration
@ConfigurationProperties(prefix = "forum.auth")
data class AuthProperties(
    var login: LoginProperties = LoginProperties(),
    var refresh: RefreshProperties = RefreshProperties(),
    var token: TokenProperties = TokenProperties()
)

data class LoginProperties(
    var path: String = ""
)

data class RefreshProperties(
    var path: String = ""
)

data class TokenProperties(
    var secret: String = "",
    var prefix: String = "",
    var refresh: CommonTokenProperties = CommonTokenProperties(),
    var access: CommonTokenProperties = CommonTokenProperties()
)

data class CommonTokenProperties(
    var timeout: Int = 0
)