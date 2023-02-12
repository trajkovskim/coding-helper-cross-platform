package com.codehelp.forum.common

import com.codehelp.forum.domain.*
import com.codehelp.forum.generated.rest.model.*

fun Community.toDto(): CommunityDto = CommunityDto()
    .name(this.name)
    .description(this.description)
    .image(null)
    .admin(this.user.toDto())
    .posts(this.posts.map { it.toShortDto() })
    .categories(this.categories.map { it.toDto() })
    .moderators(this.moderators.map { it.toDto() })
    .created(this.created)


fun Community.toShortDto(): ShortCommunityDto = ShortCommunityDto()
    .name(this.name)
    .description(this.description)
    .categories(this.categories.map { it.toDto() })
    .image(null)


fun Post.toShortDto(): ShortPostDto = ShortPostDto()
    .uid(this.uid.toString())
    .title(this.title)
    .user(this.user.toDto())
    .created(this.created)


fun Post.toDto(): PostDto = PostDto()
    .uid(this.uid.toString())
    .title(this.title)
    .user(this.user.toDto())
    .content(this.content)
    .created(this.created)
    .modified(this.modified)
    .comments(this.comments.map { it.toSubCommentDto() })


fun Comment.toDto(): CommentDto = CommentDto()
    .uid(this.uid.toString())
    .content(this.content)
    .user(this.user.toDto())
    .created(this.created)
    .modified(this.modified)
    .replies(
        CommentRepliesDto()
            .count(this.children.count())
            .replies(this.children.map { it.toSubCommentDto() })
    )


fun Comment.toSubCommentDto(): CommentDto = CommentDto()
    .uid(this.uid.toString())
    .content(this.content)
    .user(this.user.toDto())
    .created(this.created)
    .modified(this.modified)
    .replies(CommentRepliesDto().count(this.children.count()))


fun User.toDto(): UserDto = UserDto()
    .username(this.username)
    .email(this.email)
    .image(null)


fun Category.toDto(): CategoryDto = CategoryDto()
    .uid(this.uid.toString())
    .name(this.name)


