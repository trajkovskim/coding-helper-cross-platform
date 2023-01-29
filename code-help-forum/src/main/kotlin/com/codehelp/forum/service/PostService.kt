package com.codehelp.forum.service

import com.codehelp.forum.generated.rest.model.PostDto
import com.codehelp.forum.generated.rest.model.PostRequestDto
import com.codehelp.forum.generated.rest.model.ShortPostDto

interface PostService {

    fun create(community: String, postRequestDto: PostRequestDto): PostDto

    fun delete(uid: String)

    fun getSingle(uid: String): PostDto

    fun getAll(community: String): List<ShortPostDto>

    fun update(uid: String, postRequestDto: PostRequestDto): PostDto
}