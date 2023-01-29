package com.codehelp.forum.service.impl

import com.codehelp.forum.domain.User
import com.codehelp.forum.generated.rest.model.UserCreateDto
import com.codehelp.forum.repository.UserRepository
import com.codehelp.forum.service.UserService
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.security.core.userdetails.User as SpringUser


@Service
class UserServiceImpl(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) : UserService, UserDetailsService {


    override fun getUsers(): List<User> = userRepository.findAll()

    override fun registerUser(userDto: UserCreateDto) {
        val user: User = mapToEntity(userDto)

        userRepository.save(user)
    }


    override fun getUser(username: String): User? {
        return userRepository.findByUsername(username)
    }

    override fun getLoggedInUser(): User {
        val username = SecurityContextHolder.getContext().authentication.name

        return userRepository.findByUsername(username) ?: throw UsernameNotFoundException("No logged in user found")
    }

    override fun loadUserByUsername(username: String): UserDetails =
        userRepository.findByUsername(username)?.let { user ->
            SpringUser(user.username, user.password, listOf())
        } ?: throw UsernameNotFoundException("User not found")

    private fun mapToEntity(userCreateDto: UserCreateDto) =
        User(userCreateDto.username, passwordEncoder.encode(userCreateDto.password), userCreateDto.email)
}