package com.codehelp.forum.api

import com.codehelp.forum.common.toDto
import com.codehelp.forum.generated.rest.api.CategoryApi
import com.codehelp.forum.generated.rest.model.CategoriesDto
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.generated.rest.model.CategoryDto
import com.codehelp.forum.service.CategoryService
import org.springframework.http.ResponseEntity
import java.util.UUID

@RestControllerV1
class CategoryController(private val categoryService: CategoryService) : CategoryApi {

    override fun createCategory(categoryCreateDto: CategoryCreateDto): ResponseEntity<Void> {
        categoryService.create(categoryCreateDto)

        return ResponseEntity.ok().build()
    }

    override fun getAllCategories(): ResponseEntity<CategoriesDto> {
        val categories = categoryService.getAll()
            .map { category -> category.toDto() }
            .let { CategoriesDto().categories(it) }

        return ResponseEntity.ok().body(categories)
    }

    override fun updateCategory(uid: String?, categoryCreateDto: CategoryCreateDto): ResponseEntity<CategoryDto> {
        val updatedCategory = categoryService.update(UUID.fromString(uid), categoryCreateDto)

        return ResponseEntity.ok().body(updatedCategory)
    }


    override fun deleteCategory(uid: String?): ResponseEntity<Void> {
        categoryService.delete(UUID.fromString(uid))

        return ResponseEntity.noContent().build()
    }
}