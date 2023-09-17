package com.codehelp.forum.service

import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto

interface CommentService {

    fun getPostComments(postUid: String): List<CommentDto>

    fun getReplies(commentUid: String): List<CommentDto>

    fun create(postUid: String, commentRequestDto: CommentRequestDto): CommentDto

    fun update(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto

    fun delete(commentUid: String)

    fun reply(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto?

}