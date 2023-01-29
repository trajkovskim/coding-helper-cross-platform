package com.codehelp.forum.repository

import com.codehelp.forum.domain.Community
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CommunityRepository : JpaRepository<Community, Long> {
    fun findByName(name: String): Community?
}