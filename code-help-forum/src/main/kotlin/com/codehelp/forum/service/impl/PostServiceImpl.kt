package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.common.toDto
import com.codehelp.forum.domain.Post
import com.codehelp.forum.exception.UnauthorizedException
import com.codehelp.forum.generated.rest.model.PostDto
import com.codehelp.forum.generated.rest.model.PostRequestDto
import com.codehelp.forum.model.dto.PageInfoDto
import com.codehelp.forum.repository.CommunityRepository
import com.codehelp.forum.repository.PostRepository
import com.codehelp.forum.service.PostService
import com.codehelp.forum.service.UserService
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import java.util.*

@Service
class PostServiceImpl(
    private val postRepository: PostRepository,
    private val communityRepository: CommunityRepository,
    private val userService: UserService
) : PostService {
    override fun create(community: String, postRequestDto: PostRequestDto): PostDto {
        val loadedCommunity = communityRepository.findByName(community) ?: throw RuntimeException("not found")
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        val post = postRequestDto.mapToEntity(loadedCommunity, loggedInUser)

        return postRepository.saveAndFlush(post).toDto()
    }

    override fun delete(uid: String) {
        val post = postRepository.findByUid(UUID.fromString(uid)) ?: throw RuntimeException("not found")

        if (isNotAuthorizedToDeletePost(post)) {
            throw RuntimeException()
        }

        postRepository.delete(post)
    }

    override fun getSingle(uid: String): PostDto {
        val post = postRepository.findByUid(UUID.fromString(uid)) ?: throw RuntimeException("not found")

        return post.toDto()
    }

    override fun getAll(community: String?, pageable: Pageable): PageInfoDto<Post> {

        val postsPage =
            community?.let { postRepository.findAllByCommunity_Name(it, pageable) } ?: postRepository.findAll(pageable)

        return PageInfoDto<Post>().apply {
            totalElements = postsPage.totalElements
            totalPages = postsPage.totalPages
            items = postsPage.content
            pageNumber = pageable.pageNumber
            pageSize = pageable.pageSize}
    }

    override fun update(uid: String, postRequestDto: PostRequestDto): PostDto {
        val post = postRepository.findByUid(UUID.fromString(uid)) ?: throw RuntimeException("not found")


        if (!isAuthorizedToUpdatePost(post)) {
            throw RuntimeException("Not authorized")
        }

        val newPost = post.copy(
            title = postRequestDto.title,
            content = postRequestDto.content,
        )

        return postRepository.saveAndFlush(newPost).toDto()
    }

    private fun isAuthorizedToUpdatePost(post: Post): Boolean {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        return loggedInUser.id == post.user.id
    }

    private fun isAuthorizedToDeletePost(post: Post): Boolean {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        return userService.isAllowedToManageResource(post)
                || loggedInUser.moderating.contains(post.community)
                || loggedInUser.id == post.community.user.id
    }

    private fun isNotAuthorizedToDeletePost(post: Post): Boolean = !isAuthorizedToDeletePost(post)
}

