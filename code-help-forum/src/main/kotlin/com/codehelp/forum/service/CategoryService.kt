package com.codehelp.forum.service

import com.codehelp.forum.domain.Category
import com.codehelp.forum.generated.rest.model.CategoryCreateDto

interface CategoryService {

    fun getAll(): List<Category>

    fun create(categoryCreateDto: CategoryCreateDto)
}