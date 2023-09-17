package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.common.toDto
import com.codehelp.forum.domain.Community
import com.codehelp.forum.domain.User
import com.codehelp.forum.exception.ForbiddenException
import com.codehelp.forum.exception.UnauthorizedException
import com.codehelp.forum.generated.rest.model.CommunityDto
import com.codehelp.forum.generated.rest.model.CommunityRequestDto
import com.codehelp.forum.generated.rest.model.ModeratorRequestDto
import com.codehelp.forum.generated.rest.model.UserDto
import com.codehelp.forum.repository.CategoryRepository
import com.codehelp.forum.repository.CommunityRepository
import com.codehelp.forum.service.CommunityService
import com.codehelp.forum.service.UserService
import org.springframework.http.HttpStatus
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.client.HttpClientErrorException.Unauthorized
import java.net.http.HttpHeaders
import java.util.*

@Service
class CommunityServiceImpl(
    private val communityRepository: CommunityRepository,
    private val categoryRepository: CategoryRepository,
    private val userService: UserService
) : CommunityService {

    @Transactional
    override fun createCommunity(communityCreateDto: CommunityRequestDto): CommunityDto {
        val user = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val newCommunity = communityCreateDto.mapToEntity(
            user,
            categoryRepository.findAllByUidIn(communityCreateDto.categories.uids.map { s -> UUID.fromString(s) })
        )

        val savedCommunity = communityRepository.saveAndFlush(newCommunity)

        return savedCommunity.toDto(user.username)
    }

    @Transactional
    override fun updateCommunity(name: String, communityCreateDto: CommunityRequestDto): CommunityDto {
        val user = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val community = communityRepository.findByName(name) ?: throw RuntimeException()
        val categories =
            categoryRepository.findAllByUidIn(communityCreateDto.categories.uids.map { s -> UUID.fromString(s) })

        if (isNotAdmin(community)) {
            throw RuntimeException()
        }

        val newCommunity = community.copy(
            name = communityCreateDto.name,
            description = communityCreateDto.description,
            categories = categories
        )

        val savedCommunity = communityRepository.saveAndFlush(newCommunity)

        return savedCommunity.toDto(user.username)
    }

    @Transactional
    override fun deleteCommunity(name: String) {
        val community = communityRepository.findByName(name) ?: throw RuntimeException()

        if (isNotAdmin(community)) {
            throw ForbiddenException()
        }

        communityRepository.delete(community)
    }

    @Transactional(readOnly = true)
    override fun getAll(): List<Community> = communityRepository.findAll()

    @Transactional(readOnly = true)
    override fun getByName(name: String): CommunityDto {
        val user = userService.getLoggedInUser()

        return communityRepository.findByName(name)?.toDto(user?.username) ?: throw RuntimeException()
    }


    @Transactional(readOnly = true)
    override fun getModerators(name: String): List<UserDto> =
        communityRepository.findByName(name)?.moderators
            ?.map { mod -> mod.toDto() }
            ?: throw RuntimeException()


    @Transactional
    override fun addModerator(name: String, moderatorRequestDto: ModeratorRequestDto): CommunityDto {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val community = communityRepository.findByName(name) ?: throw RuntimeException("")
        val user = userService.getUser(moderatorRequestDto.username) ?: throw UsernameNotFoundException("")

        if (isNotAdmin(community)) {
            throw RuntimeException()
        }

        val newCommunity = community.copy(
            moderators = community.moderators + user
        )

        return communityRepository.saveAndFlush(newCommunity).toDto(loggedInUser.username)
    }

    @Transactional
    override fun removeModerator(name: String, moderatorRequestDto: ModeratorRequestDto): CommunityDto {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val community = communityRepository.findByName(name) ?: throw RuntimeException("")
        val user = community.moderators.find { user -> user.username == moderatorRequestDto.username }
            ?: throw UsernameNotFoundException("")

        if (isNotAdmin(community)) {
            throw RuntimeException()
        }

        val newCommunity = community.copy(
            moderators = community.moderators - user
        )

        return communityRepository.saveAndFlush(newCommunity).toDto(loggedInUser.username)
    }

    @Transactional
    override fun join(name: String): CommunityDto {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val community = communityRepository.findByName(name) ?: throw RuntimeException("")
        val user = userService.getLoggedInUser()

        val newMembers = user?.let { community.members - it } ?: community.members
        val newCommunity = community.copy(
            members = newMembers
        )

        return communityRepository.save(newCommunity).toDto(loggedInUser.username)
    }

    @Transactional
    override fun leave(name: String): CommunityDto {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()
        val community = communityRepository.findByName(name) ?: throw RuntimeException("")
        val user = userService.getLoggedInUser()

        val newMembers = user?.let { community.members - it } ?: community.members
        val newCommunity = community.copy(
                members = newMembers
        )

        return communityRepository.save(newCommunity).toDto(loggedInUser.username)
    }

    private fun isAdmin(community: Community): Boolean {
        val loggedInUser = userService.getLoggedInUser() ?: throw UnauthorizedException()

        return loggedInUser.id == community.user.id
    }

    private fun isNotAdmin(community: Community): Boolean = !isAdmin(community)
}