package com.codehelp.forum.service

import com.codehelp.forum.domain.User
import com.codehelp.forum.generated.rest.model.UserCreateDto

interface UserService {

    fun getUsers(): List<User>

    fun registerUser(userDto: UserCreateDto)

    fun getUser(username: String): User?

    fun getLoggedInUser(): User
}