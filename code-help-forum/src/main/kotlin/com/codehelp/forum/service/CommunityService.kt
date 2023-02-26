package com.codehelp.forum.service

import com.codehelp.forum.domain.Community
import com.codehelp.forum.generated.rest.model.CommunityDto
import com.codehelp.forum.generated.rest.model.CommunityRequestDto
import com.codehelp.forum.generated.rest.model.ModeratorRequestDto
import com.codehelp.forum.generated.rest.model.UserDto

interface CommunityService {
    fun createCommunity(communityCreateDto: CommunityRequestDto): CommunityDto

    fun updateCommunity(name: String, communityCreateDto: CommunityRequestDto): CommunityDto

    fun deleteCommunity(name: String)

    fun getAll(): List<Community>

    fun getByName(name: String): CommunityDto

    fun getModerators(name: String): List<UserDto>

    fun addModerator(name: String, moderatorRequestDto: ModeratorRequestDto): CommunityDto

    fun removeModerator(name: String, moderatorRequestDto: ModeratorRequestDto): CommunityDto

    fun join(name: String): CommunityDto

    fun leave(name: String): CommunityDto
}