package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.common.toDto
import com.codehelp.forum.domain.Comment
import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.repository.CommentRepository
import com.codehelp.forum.repository.PostRepository
import com.codehelp.forum.service.CommentService
import com.codehelp.forum.service.UserService
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
    override fun getPostComments(postUid: String): List<CommentDto> {
        val post = postRepository.findByUid(UUID.fromString(postUid)) ?: throw RuntimeException("not found")

        val coms = post.comments
            .filter { it.parent == null }
            .map { it.toDto() }
            .reversed()

        return listOf(
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
            coms.get(0),
        )
    }

    @Transactional(readOnly = true)
    override fun getReplies(commentUid: String): List<CommentDto> {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")

        return comment.children.map { it.toDto() }
    }

    @Transactional
    override fun create(postUid: String, commentRequestDto: CommentRequestDto): CommentDto {
        val post = postRepository.findByUid(UUID.fromString(postUid)) ?: throw RuntimeException("not found")
        val loggedInUser = userService.getLoggedInUser()

        val comment = commentRequestDto.mapToEntity(post, loggedInUser)

        return commentRepository.saveAndFlush(comment).toDto()
    }

    @Transactional
    override fun update(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")

        if (isNotAuthorizedToUpdateComment(comment)) {
            throw RuntimeException("Not authorized")
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
            throw RuntimeException("Not authorized to delete comment")
        }


        commentRepository.delete(comment)
    }

    @Transactional
    override fun reply(commentUid: String, commentRequestDto: CommentRequestDto): CommentDto? {
        val comment = commentRepository.findByUid(UUID.fromString(commentUid)) ?: throw RuntimeException("not found")
        val loggedInUser = userService.getLoggedInUser()

        val newComment = commentRequestDto.mapToEntity(comment, loggedInUser)

        return commentRepository.saveAndFlush(newComment).toDto()
    }

    private fun isAuthorizedToUpdateComment(comment: Comment): Boolean {
        val loggedInUser = userService.getLoggedInUser()

        return loggedInUser.username == comment.user.username
    }

    private fun isNotAuthorizedToUpdateComment(comment: Comment): Boolean = !isAuthorizedToUpdateComment(comment)

    private fun isAuthorizedToDeleteComment(comment: Comment): Boolean {
        val loggedInUser = userService.getLoggedInUser()

        return loggedInUser.username == comment.user.username
                || loggedInUser.moderating.contains(comment.post.community)
                || loggedInUser.username == comment.post.community.user.username
    }

    private fun isNotAuthorizedToDeleteComment(comment: Comment): Boolean = !isAuthorizedToDeleteComment(comment)
}

