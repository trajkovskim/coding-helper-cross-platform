package com.codehelp.forum.repository

import com.codehelp.forum.domain.Comment
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface CommentRepository : JpaRepository<Comment, Long> {
    fun findByUid(uid: UUID): Comment?

    fun findByParentUid(parentUid: UUID, pageable: Pageable): Page<Comment>

    fun findAllByPostUidAndParentIsNull(postUID: UUID, pageable: Pageable): Page<Comment>
}