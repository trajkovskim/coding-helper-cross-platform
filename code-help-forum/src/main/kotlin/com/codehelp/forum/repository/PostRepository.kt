package com.codehelp.forum.repository

import com.codehelp.forum.domain.Post
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface PostRepository : JpaRepository<Post, Long> {
    fun findByUid(uid: UUID): Post?

    fun findAllByCommunityName(name: String): List<Post>
}