package com.codehelp.forum.api

import com.codehelp.forum.common.toDto
import com.codehelp.forum.factory.LinksFactory
import com.codehelp.forum.generated.rest.api.CommentApi
import com.codehelp.forum.generated.rest.model.CommentDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.generated.rest.model.CommentsDto
import com.codehelp.forum.service.CommentService
import com.codehelp.forum.util.PageUtil
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn
import org.springframework.http.ResponseEntity

@RestControllerV1
class CommentController(private val commentService: CommentService, private val linksFactory: LinksFactory) : CommentApi {
    override fun commentOnPost(post: String, commentRequestDto: CommentRequestDto): ResponseEntity<CommentDto> {
        val comment = commentService.create(post, commentRequestDto)

        return ResponseEntity.ok(comment)
    } 

    override fun getCommentReplies(uid: String, page: Int, size: Int, sortBy: List<String>): ResponseEntity<CommentsDto> {

        val pageable = PageUtil.createPageRequest(page, size, sortBy)
        val repliesPage = commentService.getReplies(uid, pageable)

        val paginationLinks = linksFactory.createPaginationLinks(
            repliesPage
        ) { pageNumber, pageSize ->
            methodOn(CommentController::class.java).getCommentReplies(uid, pageNumber, pageSize, sortBy)
        }

        val dto = CommentsDto()
            .pageNumber(page)
            .pageSize(size)
            .totalElements(repliesPage.totalElements)
            .totalPages(repliesPage.totalPages)
            .comments(repliesPage.items.map { it.toDto() })
            .links(paginationLinks)

        return ResponseEntity.ok(dto)
    }

    override fun getCommentsForPost(post: String, page: Int, size: Int, sortBy: List<String>): ResponseEntity<CommentsDto> {

        val pageable = PageUtil.createPageRequest(page, size, sortBy)
        val commentsPage = commentService.getPostComments(post, pageable)

        val paginationLinks = linksFactory.createPaginationLinks(
            commentsPage
        ) { pageNumber, pageSize ->
            methodOn(CommentController::class.java).getCommentsForPost(post, pageNumber, pageSize, sortBy)
        }

        val dto = CommentsDto()
            .pageNumber(page)
            .pageSize(size)
            .totalElements(commentsPage.totalElements)
            .totalPages(commentsPage.totalPages)
            .comments(commentsPage.items.map { it.toDto() })
            .links(paginationLinks)

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