package com.codehelp.forum.service.impl

import com.codehelp.forum.domain.User
import com.codehelp.forum.repository.UserRepository
import com.codehelp.forum.service.UserService
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.oauth2.jwt.Jwt
import org.springframework.stereotype.Service
import java.util.*
import kotlin.jvm.optionals.getOrNull

@Service
class UserServiceImpl(
    private val userRepository: UserRepository,
) : UserService {

  override fun getUser(username: String): User? {
    return userRepository.findByUsername(username)
  }

  override fun getLoggedInUser(): User? {
    val authentication = SecurityContextHolder.getContext().authentication
    if (authentication.principal !is Jwt) return null

    val principal = authentication.principal as Jwt

    val userId = UUID.fromString(authentication.name)
    val username = principal.getClaimAsString("preferred_username")

    return userRepository.findById(userId).getOrNull()
        ?: userRepository.findByUsername(username)
        ?: createUser(User(userId, username))
  }

  private fun createUser(user: User): User {
    userRepository.save(user)
    return user
  }
}