package com.codehelp.forum.service.impl

import com.codehelp.forum.common.mapToEntity
import com.codehelp.forum.common.toDto
import com.codehelp.forum.domain.Category
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.generated.rest.model.CategoryDto
import com.codehelp.forum.repository.CategoryRepository
import com.codehelp.forum.service.CategoryService
import jakarta.persistence.EntityNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

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

    @Transactional
    override fun update(uid: UUID, categoryCreateDto: CategoryCreateDto): CategoryDto {
        val category = categoryCreateDto.mapToEntity()

        val foundCategory = categoryRepository.findByUid(uid) ?: throw EntityNotFoundException()

        val updatedCategory = foundCategory.copy(
            name = category.name
        )

        return categoryRepository.saveAndFlush(updatedCategory).toDto()
    }


    @Transactional
    override fun delete(uid: UUID) {

        categoryRepository.deleteByUid(uid)
    }
}

