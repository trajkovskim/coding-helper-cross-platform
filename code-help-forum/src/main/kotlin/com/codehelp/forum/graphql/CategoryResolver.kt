package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.CategoriesQueryResolver
import com.codehelp.forum.generated.graphql.api.CategoryByIdQueryResolver
import com.codehelp.forum.generated.graphql.api.CategoryByNameQueryResolver
import com.codehelp.forum.generated.graphql.api.CreateCategoryMutationResolver
import com.codehelp.forum.generated.graphql.model.CategoryDto
import com.codehelp.forum.generated.graphql.model.CategoryInputDto
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class CategoryQueryResolver : CategoriesQueryResolver, CategoryByIdQueryResolver, CategoryByNameQueryResolver {

    override fun categories(categoryName: String?, env: DataFetchingEnvironment): List<CategoryDto> {
        TODO("Not yet implemented")
    }

    override fun categoryById(categoryId: String, env: DataFetchingEnvironment): CategoryDto {
        TODO("Not yet implemented")
    }

    override fun categoryByName(categoryName: String, env: DataFetchingEnvironment): CategoryDto {
        TODO("Not yet implemented")
    }
}

@Controller
class CategoryMutationResolver : CreateCategoryMutationResolver {
    override fun createCategory(categoryInput: CategoryInputDto, env: DataFetchingEnvironment): CategoryDto {
        TODO("Not yet implemented")
    }


}

