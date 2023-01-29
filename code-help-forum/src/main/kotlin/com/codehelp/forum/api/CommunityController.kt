package com.codehelp.forum.api

import com.codehelp.forum.common.toShortDto
import com.codehelp.forum.generated.rest.api.CommunityApi
import com.codehelp.forum.generated.rest.model.*
import com.codehelp.forum.service.CommunityService
import org.springframework.http.ResponseEntity

@RestControllerV1
class CommunityController(
    private val communityService: CommunityService
) : CommunityApi {


    override fun createCommunity(communityRequestDto: CommunityRequestDto): ResponseEntity<CommunityDto> {
        return ResponseEntity.ok(communityService.createCommunity(communityRequestDto))
    }

    override fun deleteCommunity(name: String): ResponseEntity<Void> {
        communityService.deleteCommunity(name)

        return ResponseEntity.ok().build()
    }

    override fun getAllCommunities(): ResponseEntity<ShortCommunitiesDto> {
        val communities = communityService.getAll().map { it.toShortDto() }

        val dto = ShortCommunitiesDto().communities(communities)

        return ResponseEntity.ok(dto)
    }

    override fun getCommunityByUid(name: String): ResponseEntity<CommunityDto> {
        return ResponseEntity.ok(communityService.getByName(name))
    }

    override fun updateCommunity(name: String, communityRequestDto: CommunityRequestDto): ResponseEntity<CommunityDto> {
        val community = communityService.updateCommunity(name, communityRequestDto)

        return ResponseEntity.ok(community)
    }

    override fun getCommunityModerators(name: String): ResponseEntity<UsersDto> {
        val moderators = communityService.getModerators(name)

        val dto = UsersDto().users(moderators)

        return ResponseEntity.ok(dto)
    }

    override fun joinCommunity(community: String): ResponseEntity<Void> {
        communityService.join(community)

        return ResponseEntity.ok().build()
    }

    override fun leaveCommunity(community: String): ResponseEntity<Void> {
        communityService.leave(community)

        return ResponseEntity.ok().build()
    }

    override fun removeModerator(name: String, moderatorRequestDto: ModeratorRequestDto): ResponseEntity<Void> {
        communityService.removeModerator(name, moderatorRequestDto)

        return ResponseEntity.ok().build()
    }

    override fun addANewModeratorToTheCommunity(
        name: String,
        moderatorRequestDto: ModeratorRequestDto
    ): ResponseEntity<Void> {
        communityService.addModerator(name, moderatorRequestDto)

        return ResponseEntity.ok().build()
    }


}