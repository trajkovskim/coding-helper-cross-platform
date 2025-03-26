package com.codehelp.forum.repository

import com.codehelp.forum.domain.Post
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface PostRepository : JpaRepository<Post, Long> {

    fun findByUid(@Param("uid") uid: UUID): Post?

    fun findAllByCommunity_Name(name: String, pageable: Pageable): Page<Post>
}