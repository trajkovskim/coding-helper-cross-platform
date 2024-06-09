package com.codehelp.forum.service

import com.codehelp.forum.domain.User
import com.codehelp.forum.domain.UserCreatedResource
import com.codehelp.forum.domain.UserRole

interface UserService {

    fun getLoggedInUser(): User?

    fun getUser(username: String): User?

    fun isLoggedInUserCreator(resource: UserCreatedResource): Boolean

    fun loggedInUserHasRole(role: UserRole): Boolean

    fun isAllowedToManageResource(resource: UserCreatedResource): Boolean
}