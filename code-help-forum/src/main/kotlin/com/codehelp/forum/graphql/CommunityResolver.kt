package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.*
import com.codehelp.forum.generated.graphql.api.CommunityQueryResolver
import com.codehelp.forum.generated.graphql.model.CommunityDto
import com.codehelp.forum.generated.graphql.model.CommunityInputDto
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class CommunityQueryResolver: CommunityQueryResolver, CommunitiesQueryResolver  {
    override fun communities(env: DataFetchingEnvironment): List<CommunityDto> {
        TODO("Not yet implemented")
    }

    override fun community(communityId: String, env: DataFetchingEnvironment): CommunityDto {
        TODO("Not yet implemented")
    }
}

@Controller
class CommunityMutationResolver: CreateCommunityMutationResolver, JoinCommunityMutationResolver, DeleteByIdMutationResolver, ChangeAvatarMutationResolver {
    override fun createCommunity(
        adminId: String,
        categoryName: String,
        communityInput: CommunityInputDto,
        env: DataFetchingEnvironment
    ): CommunityDto {
        TODO("Not yet implemented")
    }

    override fun joinCommunity(communityId: String, userId: String, env: DataFetchingEnvironment): CommunityDto {
        TODO("Not yet implemented")
    }

    override fun deleteById(communityId: String, env: DataFetchingEnvironment): CommunityDto {
        TODO("Not yet implemented")
    }

    override fun changeAvatar(communityId: String, env: DataFetchingEnvironment): CommunityDto {
        TODO("Not yet implemented")
    }
}