package com.codehelp.forum.common

import com.codehelp.forum.domain.*
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.generated.rest.model.CommentRequestDto
import com.codehelp.forum.generated.rest.model.CommunityRequestDto
import com.codehelp.forum.generated.rest.model.PostRequestDto

fun CommunityRequestDto.mapToEntity(user: User, categories: List<Category>) = Community(
    name = this.name,
    description = this.description,
    user = user,
    categories = categories
)


fun PostRequestDto.mapToEntity(community: Community, user: User) = Post(
    title = this.title,
    content = this.content,
    community = community,
    user = user
)


fun CommentRequestDto.mapToEntity(post: Post, user: User) = Comment(
    content = this.content,
    post = post,
    user = user
)


fun CommentRequestDto.mapToEntity(comment: Comment, user: User) = Comment(
    content = this.content,
    post = comment.post,
    parent = comment,
    user = user
)


fun CategoryCreateDto.mapToEntity() = Category(name = this.name)

