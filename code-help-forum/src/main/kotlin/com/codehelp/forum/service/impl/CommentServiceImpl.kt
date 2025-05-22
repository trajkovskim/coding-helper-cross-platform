package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.common.toDto
import com.codehelp.forum.domain.Comment
import com.codehelp.forum.exception.ForbiddenException
import com.codehelp.forum.exception.UnauthorizedException
import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.model.dto.PageInfoDto
import com.codehelp.forum.repository.CommentRepository
import com.codehelp.forum.repository.PostRepository
import com.codehelp.forum.service.CommentService
import com.codehelp.forum.service.UserService
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*


@Service
class CommentServiceImpl(
    private val commentRepository: CommentRepository,
    private val postRepository: PostRepository,
    private val userService: UserService
) : CommentService {

    @Transactional(readOnly = true)
    override fun getPostComments(postUid: String, pageable: Pageable): PageInfoDto<Comment> {
        val commentsPage = commentRepository.findAllByPostUidAndParentIsNull(UUID.fromString(postUid), pageable)

        return PageInfoDto<Comment>().apply {
            totalElements = commentsPage.totalElements
            totalPages = commentsPage.totalPages
            items = commentsPage.content
            pageNumber = pageable.pageNumber
            pageSize = pageable.pageSize}
    }

    @Transactional(readOnly = true)
    override fun getReplies(commentUid: String, pageable: Pageable): PageInfoDto<Comment> {
        val commentsPage = commentRepository.findByParentUid(UUID.fromString(commentUid), pageable)

        return PageInfoDto<Comment>().apply {
            totalElements = commentsPage.totalElements
            totalPages = commentsPage.totalPages
            items = commentsPage.content
            pageNumber = pageable.pageNumber
            pageSize = pageable.pageSize}
    }

    @Transactional
    override fun create(postUid: String, commentRequestDto: CommentRequestDto): CommentDto {
        val post = postRepository.findByUid(UUID.fromString(postUid)) ?: throw RuntimeException("not found")
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        val comment = commentRequestDto.mapToEntity(post, loggedInUser)

        return commentRepository.saveAndFlush(comment).toDto()
    }

    @Transactional
    override fun update(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")

        if (isNotAuthorizedToUpdateComment(comment)) {
            throw ForbiddenException()
        }

        val newComment = comment.copy(
            content = commentRequestDto.content
        )

        return commentRepository.saveAndFlush(newComment).toDto()
    }

    @Transactional
    override fun delete(commentUid: String) {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")

        if (isNotAuthorizedToDeleteComment(comment)) {
            throw ForbiddenException()
        }


        commentRepository.delete(comment)
    }

    @Transactional
    override fun reply(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto? {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        val newComment = commentRequestDto.mapToEntity(comment, loggedInUser)

        return commentRepository.saveAndFlush(newComment).toDto()
    }

    private fun isAuthorizedToUpdateComment(comment: Comment): Boolean {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        return loggedInUser.id == comment.user.id
    }

    private fun isNotAuthorizedToUpdateComment(comment: Comment): Boolean = !isAuthorizedToUpdateComment(comment)

    private fun isAuthorizedToDeleteComment(comment: Comment): Boolean {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        return userService.isAllowedToManageResource(comment)
                || loggedInUser.moderating.contains(comment.post.community)
                || loggedInUser.id == comment.post.community.user.id
    }

    private fun isNotAuthorizedToDeleteComment(comment: Comment): Boolean = !isAuthorizedToDeleteComment(comment)
}

