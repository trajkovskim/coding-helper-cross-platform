package com.codehelp.forum.api

import com.codehelp.forum.common.toDto
import com.codehelp.forum.factory.LinksFactory
import com.codehelp.forum.generated.rest.api.CategoryApi
import com.codehelp.forum.generated.rest.model.CategoriesDto
import com.codehelp.forum.generated.rest.model.CategoryCreateDto
import com.codehelp.forum.generated.rest.model.CategoryDto
import com.codehelp.forum.generated.rest.model.CreatedResponseDto
import com.codehelp.forum.service.CategoryService
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.util.UUID

@RestControllerV1
class CategoryController(private val categoryService: CategoryService, private val linksFactory: LinksFactory) : CategoryApi {

    override fun createCategory(categoryCreateDto: CategoryCreateDto): ResponseEntity<CreatedResponseDto> {
        categoryService.create(categoryCreateDto)

        val links = linksFactory.createSelfLink(methodOn(CategoryController::class.java).getAllCategories())
        val response = CreatedResponseDto().apply { this.links = links }

        return ResponseEntity.status(HttpStatus.CREATED).body(response)
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