package com.codehelp.forum.api

import com.codehelp.forum.common.toShortDto
import com.codehelp.forum.factory.LinksFactory
import com.codehelp.forum.generated.rest.api.PostApi
import com.codehelp.forum.generated.rest.model.PostDto
import com.codehelp.forum.generated.rest.model.PostRequestDto
import com.codehelp.forum.generated.rest.model.ShortPostsDto
import com.codehelp.forum.service.PostService
import com.codehelp.forum.util.PageUtil
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn
import org.springframework.http.ResponseEntity

@RestControllerV1
class PostController(private val postService: PostService, private val linksFactory: LinksFactory) : PostApi {
    override fun createCommunityPost(postRequestDto: PostRequestDto, community: String): ResponseEntity<PostDto> {
        val post = postService.create(community, postRequestDto)

        return ResponseEntity.ok(post)
    }

    override fun deletePost(uid: String): ResponseEntity<Void> {
        postService.delete(uid)

        return ResponseEntity.ok().build()
    }

    override fun getPost(uid: String): ResponseEntity<PostDto> {
        val post = postService.getSingle(uid)

        return ResponseEntity.ok(post)
    }

    override fun getPosts(page: Int, size: Int, sortBy: List<String>, community: String?): ResponseEntity<ShortPostsDto> {

        val pageable = PageUtil.createPageRequest(page, size, sortBy)
        val postsPage = postService.getAll(community, pageable)

        val paginationLinks = linksFactory.createPaginationLinks(
            postsPage
        ) { pageNumber, pageSize ->
            methodOn(PostController::class.java).getPosts(pageNumber, pageSize, sortBy, community)
        }

        val dto = ShortPostsDto()
            .pageNumber(page)
            .pageSize(size)
            .totalElements(postsPage.totalElements)
            .totalPages(postsPage.totalPages)
            .posts(postsPage.items.map { it.toShortDto() })
            .links(paginationLinks)

        return ResponseEntity.ok(dto)
    }

    override fun updatePost(uid: String, postRequestDto: PostRequestDto): ResponseEntity<PostDto> {
        val post = postService.update(uid, postRequestDto)

        return ResponseEntity.ok(post)
    }

}