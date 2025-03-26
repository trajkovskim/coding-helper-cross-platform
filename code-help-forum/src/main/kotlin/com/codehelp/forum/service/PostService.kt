package com.codehelp.forum.service

import com.codehelp.forum.domain.Post
import com.codehelp.forum.generated.rest.model.PostDto
import com.codehelp.forum.generated.rest.model.PostRequestDto
import com.codehelp.forum.model.dto.PageInfoDto
import org.springframework.data.domain.Pageable

interface PostService {

    fun create(community: String, postRequestDto: PostRequestDto): PostDto

    fun delete(uid: String)

    fun getSingle(uid: String): PostDto

    fun getAll(community: String?, pageable: Pageable): PageInfoDto<Post>

    fun update(uid: String, postRequestDto: PostRequestDto): PostDto
}