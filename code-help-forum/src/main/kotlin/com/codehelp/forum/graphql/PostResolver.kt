package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.CreatePostMutationResolver
import com.codehelp.forum.generated.graphql.api.PostsQueryResolver
import com.codehelp.forum.generated.graphql.model.PostDto
import com.codehelp.forum.generated.graphql.model.PostInputDto
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class PostQueryResolver: PostsQueryResolver {
    override fun posts(env: DataFetchingEnvironment): List<PostDto> {
        TODO("Not yet implemented")
    }

}


@Controller
class PostMutationResolver: CreatePostMutationResolver {
    override fun createPost(
        communityId: String,
        postInput: PostInputDto,
        userId: String,
        env: DataFetchingEnvironment
    ): PostDto {
        TODO("Not yet implemented")
    }

}