package com.codehelp.forum.service

import com.codehelp.forum.domain.Comment
import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.model.dto.PageInfoDto
import org.springframework.data.domain.Pageable

interface CommentService {

    fun getPostComments(postUid: String, pageable: Pageable): PageInfoDto<Comment>

    fun getReplies(commentUid: String, pageable: Pageable): PageInfoDto<Comment>

    fun create(postUid: String, commentRequestDto: CommentRequestDto): CommentDto

    fun update(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto

    fun delete(commentUid: String)

    fun reply(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto?

}