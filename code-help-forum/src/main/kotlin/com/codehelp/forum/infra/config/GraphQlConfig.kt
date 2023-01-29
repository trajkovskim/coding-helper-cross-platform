package com.codehelp.forum.infra.config

import graphql.scalars.ExtendedScalars
import graphql.schema.GraphQLScalarType
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class GraphQlConfig {
    @Bean
    fun dateTimeExtendedScalar(): GraphQLScalarType? {
        return ExtendedScalars.DateTime
    }
}