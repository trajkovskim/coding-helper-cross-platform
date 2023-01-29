package com.codehelp.forum.api

import com.codehelp.forum.generated.rest.api.CommentApi
import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.generated.rest.model.CommentsDto
import com.codehelp.forum.service.CommentService
import org.springframework.http.ResponseEntity

@RestControllerV1
class CommentController(private val commentService: CommentService) : CommentApi {
    override fun commentOnPost(post: String, commentRequestDto: CommentRequestDto): ResponseEntity<CommentDto> {
        val comment = commentService.create(post, commentRequestDto)

        return ResponseEntity.ok(comment)
    }

    override fun getCommentReplies(uid: String): ResponseEntity<CommentsDto> {
        val replies = commentService.getReplies(uid)

        val dto = CommentsDto().comments(replies)

        return ResponseEntity.ok(dto)
    }

    override fun getCommentsForPost(post: String): ResponseEntity<CommentsDto> {
        val comments = commentService.getPostComments(post)


        val dto = CommentsDto().comments(comments)

        return ResponseEntity.ok(dto)
    }

    override fun replyToComment(uid: String, commentRequestDto: CommentRequestDto): ResponseEntity<CommentDto> {
        val comment = commentService.reply(uid, commentRequestDto)

        return ResponseEntity.ok(comment)
    }

    override fun updateComment(uid: String, commentRequestDto: CommentRequestDto): ResponseEntity<CommentDto> {
        val comment = commentService.update(uid, commentRequestDto)

        return ResponseEntity.ok(comment)
    }

    override fun deleteComment(uid: String): ResponseEntity<Void> {
        commentService.delete(uid)

        return ResponseEntity.ok().build()
    }

}