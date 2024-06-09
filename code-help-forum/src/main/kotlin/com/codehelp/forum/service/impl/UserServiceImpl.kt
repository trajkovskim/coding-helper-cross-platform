package com.codehelp.forum.service.impl

import com.codehelp.forum.domain.User
import com.codehelp.forum.domain.UserCreatedResource
import com.codehelp.forum.domain.UserRole
import com.codehelp.forum.repository.UserRepository
import com.codehelp.forum.service.UserService
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.oauth2.jwt.Jwt
import org.springframework.stereotype.Service
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.List
import kotlin.jvm.optionals.getOrNull

@Service
class UserServiceImpl(
    private val userRepository: UserRepository,
) : UserService {

  override fun getUser(username: String): User? {
    return userRepository.findByUsername(username)
  }

  fun getLoggedInUserPrincipal(): Jwt? {

    val authentication = SecurityContextHolder.getContext().authentication

    val principal = authentication.principal
    if (principal !is Jwt) return null

    return principal
  }

  override fun getLoggedInUser(): User? {
    val principal = getLoggedInUserPrincipal() ?: return null

    val userId = UUID.fromString(principal.id)
    val username = principal.getClaimAsString("preferred_username")

    return userRepository.findById(userId).getOrNull()
        ?: userRepository.findByUsername(username)
        ?: createUser(User(userId, username))
  }

  override fun isLoggedInUserCreator(resource: UserCreatedResource): Boolean {

    val loggedInUser: User? = getLoggedInUser()

    return loggedInUser?.username == resource.user.username
  }

  override fun loggedInUserHasRole(role: UserRole): Boolean {

    val principal = getLoggedInUserPrincipal() ?: return false

    val realmAccess: MutableMap<String, Any>? = principal.getClaimAsMap("realm_access")

    val roles: List<String>? = realmAccess?.get("roles") as ArrayList<String>?

    return roles?.contains(role.role) ?: false
  }

  override fun isAllowedToManageResource(resource: UserCreatedResource): Boolean {

    return isLoggedInUserCreator(resource) || loggedInUserHasRole(UserRole.ADMIN)
  }

  private fun createUser(user: User): User {
    userRepository.save(user)
    return user
  }
}