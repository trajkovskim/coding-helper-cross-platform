package com.codehelp.forum.api

import com.codehelp.forum.generated.rest.api.PostApi
import com.codehelp.forum.generated.rest.model.PostDto
import com.codehelp.forum.generated.rest.model.PostRequestDto
import com.codehelp.forum.generated.rest.model.ShortPostsDto
import com.codehelp.forum.service.PostService
import org.springframework.http.ResponseEntity

@RestControllerV1
class PostController(private val postService: PostService) : PostApi {
    override fun createCommunityPost(community: String, postRequestDto: PostRequestDto): ResponseEntity<PostDto> {
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

    override fun getPosts(community: String?): ResponseEntity<ShortPostsDto> {
        val posts = postService.getAll(community)

        val dto = ShortPostsDto()
            .posts(posts.stream().toList())

        return ResponseEntity.ok(dto)
    }

    override fun updatePost(uid: String, postRequestDto: PostRequestDto): ResponseEntity<PostDto> {
        val post = postService.update(uid, postRequestDto)

        return ResponseEntity.ok(post)
    }

}