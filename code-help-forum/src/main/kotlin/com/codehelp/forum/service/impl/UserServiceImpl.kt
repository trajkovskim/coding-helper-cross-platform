package com.codehelp.forum.service.impl

import com.codehelp.forum.domain.User
import com.codehelp.forum.repository.UserRepository
import com.codehelp.forum.service.UserService
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service

@Service
class UserServiceImpl(
    private val userRepository: UserRepository,
) : UserService {

  override fun getUser(username: String): User? {
    return userRepository.findByUsername(username)
  }

  override fun getLoggedInUser(): User {
    val authentication = SecurityContextHolder.getContext().authentication
    val userId = authentication.name
    val user = userRepository.findById(userId)

    if (user.isEmpty) {
      return createUser(User(userId, authentication.name))
    }

    return user.get()
  }

  private fun createUser(user: User): User {
    userRepository.save(user)
    return user
  }
}