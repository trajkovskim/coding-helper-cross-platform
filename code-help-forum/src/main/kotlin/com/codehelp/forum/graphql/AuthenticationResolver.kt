package com.codehelp.forum.graphql

import com.codehelp.forum.generated.graphql.api.*
import com.codehelp.forum.generated.graphql.model.UserCredentialsInputDto
import com.codehelp.forum.generated.graphql.model.UserDto
import com.codehelp.forum.generated.graphql.model.UserInputDto
import com.codehelp.forum.service.impl.UserServiceImpl
import graphql.schema.DataFetchingEnvironment
import org.springframework.stereotype.Controller

@Controller
class AuthenticationQueryResolver(val authService: UserServiceImpl) : LoginUserQueryResolver, UserQueryResolver,
    UsersQueryResolver {
    override fun loginUser(userCredentialsInput: UserCredentialsInputDto, env: DataFetchingEnvironment): UserDto {
        TODO("Not yet implemented")
    }

    override fun user(userId: String, env: DataFetchingEnvironment): UserDto? {
        TODO("Not yet implemented")
    }

    override fun users(env: DataFetchingEnvironment): List<UserDto> {
//        return authService.getUsers()
        TODO("Not yet implemented")

    }


}

@Controller
class AuthenticationResolver : RegisterMutationResolver, DeleteUserMutationResolver {
    override fun deleteUser(userId: String, env: DataFetchingEnvironment): UserDto {
        TODO("Not yet implemented")
    }

    override fun register(userData: UserInputDto, env: DataFetchingEnvironment): UserDto {
        TODO("Not yet implemented")
    }

}