package com.codehelp.forum.service

import com.codehelp.forum.domain.Category
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.generated.rest.model.CategoryDto
import java.util.*

interface CategoryService {

    fun getAll(): List<Category>

    fun create(categoryCreateDto: CategoryCreateDto)

    fun delete(uid: UUID)

    fun update(uid: UUID, categoryCreateDto: CategoryCreateDto): CategoryDto
}