package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.CommentsQueryResolver
import com.codehelp.forum.generated.graphql.api.CreateCommentMutationResolver
import com.codehelp.forum.generated.graphql.api.ReplyMutationResolver
import com.codehelp.forum.generated.graphql.model.CommentDto
import com.codehelp.forum.generated.graphql.model.CommentInputDto
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class CommentsQueryResolver: CommentsQueryResolver {
    override fun comments(env: DataFetchingEnvironment): List<CommentDto> {
        TODO("Not yet implemented")
    }
}

@Controller
class CommentsMutationResolver: CreateCommentMutationResolver, ReplyMutationResolver {
    override fun createComment(
        commentInput: CommentInputDto,
        postId: String,
        userId: String,
        env: DataFetchingEnvironment
    ): CommentDto {
        TODO("Not yet implemented")
    }

    override fun reply(
        commentId: String,
        replyInput: CommentInputDto,
        userId: String,
        env: DataFetchingEnvironment
    ): CommentDto {
        TODO("Not yet implemented")
    }
}