package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.CountriesQueryResolver
import com.codehelp.forum.generated.graphql.model.CountryDto
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class CountriesQueryResolver: CountriesQueryResolver {
    override fun countries(env: DataFetchingEnvironment): List<CountryDto> {
        TODO("Not yet implemented")
    }

}