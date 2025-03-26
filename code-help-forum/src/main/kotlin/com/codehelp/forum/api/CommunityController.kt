package com.codehelp.forum.api

import com.codehelp.forum.common.toShortDto
import com.codehelp.forum.factory.LinksFactory
import com.codehelp.forum.generated.rest.api.CommunityApi
import com.codehelp.forum.generated.rest.model.*
import com.codehelp.forum.service.CommunityService
import com.codehelp.forum.util.PageUtil
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn
import org.springframework.http.ResponseEntity

@RestControllerV1
class CommunityController(
    private val communityService: CommunityService,
    private val linksFactory: LinksFactory
) : CommunityApi {


    override fun createCommunity(communityRequestDto: CommunityRequestDto): ResponseEntity<CommunityDto> {
        return ResponseEntity.ok(communityService.createCommunity(communityRequestDto))
    }

    override fun deleteCommunity(name: String): ResponseEntity<Void> {
        communityService.deleteCommunity(name)

        return ResponseEntity.ok().build()
    }

    override fun getAllCommunities(page: Int, size: Int, sortBy: List<String>): ResponseEntity<ShortCommunitiesDto> {

        val pageable = PageUtil.createPageRequest(page, size, sortBy)
        val communitiesPage = communityService.getAll(pageable)

        val paginationLinks = linksFactory.createPaginationLinks(
            communitiesPage
        ) { pageNumber, pageSize ->
            methodOn(CommunityController::class.java).getAllCommunities(pageNumber, pageSize, sortBy)
        }

        val dto = ShortCommunitiesDto()
            .pageNumber(page)
            .pageSize(size)
            .totalElements(communitiesPage.totalElements)
            .totalPages(communitiesPage.totalPages)
            .communities(communitiesPage.items.map { it.toShortDto() })
            .links(paginationLinks)

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

    override fun removeModerator(name: String, moderator: String): ResponseEntity<Void> {
        communityService.removeModerator(name, ModeratorRequestDto().username(moderator))

        return ResponseEntity.ok().build()
    }

    override fun addModerator(
        name: String,
        moderatorRequestDto: ModeratorRequestDto
    ): ResponseEntity<Void> {
        communityService.addModerator(name, moderatorRequestDto)

        return ResponseEntity.ok().build()
    }


}