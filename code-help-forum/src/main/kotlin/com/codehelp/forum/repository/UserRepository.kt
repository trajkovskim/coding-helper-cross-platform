package com.codehelp.forum.repository

import com.codehelp.forum.domain.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface UserRepository : JpaRepository<User, UUID> {

    fun findByUsername(username: String): User?
}