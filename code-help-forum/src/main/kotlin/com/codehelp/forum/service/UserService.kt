package com.codehelp.forum.service

import com.codehelp.forum.domain.User

interface UserService {

    fun getLoggedInUser(): User?

    fun getUser(username: String): User?
}