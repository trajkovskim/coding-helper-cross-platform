package com.codehelp.forum.repository

import com.codehelp.forum.domain.Category
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface CategoryRepository : JpaRepository<Category, Long> {

    fun findByUid(uid: UUID): Category?

    @Query(
        """
        select *
        from category
        where uid in (:ids)
    """, nativeQuery = true
    )
    fun findAllByUidIn(ids: List<UUID>): List<Category>

    fun deleteByUid(uid: UUID)
}