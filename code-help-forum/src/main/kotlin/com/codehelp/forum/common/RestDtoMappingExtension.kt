package com.codehelp.forum.common

import com.codehelp.forum.domain.*
import com.codehelp.forum.generated.rest.model.*
import java.time.temporal.ChronoUnit

fun Community.toDto(username: String?): CommunityDto = CommunityDto()
    .name(this.name)
    .description(this.description)
    .image(null)
    .admin(this.user.toDto())
    .posts(this.posts.map { it.toShortDto() })
    .joined(this.members.any { it.username == username })
    .categories(this.categories.map { it.toDto() })
    .moderators(this.moderators.map { it.toDto() })
    .created(this.created.truncatedTo(ChronoUnit.SECONDS))


fun Community.toShortDto(): ShortCommunityDto = ShortCommunityDto()
    .name(this.name)
    .description(this.description)
    .categories(this.categories.map { it.toDto() })
    .image(null)


fun Post.toShortDto(): ShortPostDto = ShortPostDto()
    .uid(this.uid.toString())
    .title(this.title)
    .user(this.user.toDto())
    .created(this.created.truncatedTo(ChronoUnit.SECONDS))


fun Post.toDto(): PostDto = PostDto()
    .uid(this.uid.toString())
    .title(this.title)
    .user(this.user.toDto())
    .content(this.content)
    .created(this.created.truncatedTo(ChronoUnit.SECONDS))
    .modified(this.modified.truncatedTo(ChronoUnit.SECONDS))
    .comments(this.comments.filter { it.parent == null }.map { it.toSubCommentDto() })


fun Comment.toDto(): CommentDto = CommentDto()
    .uid(this.uid.toString())
    .content(this.content)
    .user(this.user.toDto())
    .created(this.created.truncatedTo(ChronoUnit.SECONDS))
    .modified(this.modified.truncatedTo(ChronoUnit.SECONDS))
    .replies(
        CommentRepliesDto()
            .count(this.children.count())
            .replies(this.children.map { it.toSubCommentDto() })
    )


fun Comment.toSubCommentDto(): CommentDto = CommentDto()
    .uid(this.uid.toString())
    .content(this.content)
    .user(this.user.toDto())
    .created(this.created.truncatedTo(ChronoUnit.SECONDS))
    .modified(this.modified.truncatedTo(ChronoUnit.SECONDS))
    .replies(CommentRepliesDto().count(this.children.count()))


fun User.toDto(): UserDto = UserDto()
    .username(this.username)


fun Category.toDto(): CategoryDto = CategoryDto()
    .uid(this.uid.toString())
    .name(this.name)


