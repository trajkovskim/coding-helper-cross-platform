package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.domain.Category
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.repository.CategoryRepository
import com.codehelp.forum.service.CategoryService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class CategoryServiceImpl(private val categoryRepository: CategoryRepository) : CategoryService {

    @Transactional(readOnly = true)
    override fun getAll(): List<Category> {
        return categoryRepository.findAll()
    }

    @Transactional
    override fun create(categoryCreateDto: CategoryCreateDto) {
        val category = categoryCreateDto.mapToEntity()

        categoryRepository.saveAndFlush(category)
    }
}

