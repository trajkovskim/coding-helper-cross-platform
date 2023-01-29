package com.codehelp.forum.repository

import com.codehelp.forum.domain.Comment
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface CommentRepository : JpaRepository<Comment, Long> {
    fun findByUid(uid: UUID): Comment?
}