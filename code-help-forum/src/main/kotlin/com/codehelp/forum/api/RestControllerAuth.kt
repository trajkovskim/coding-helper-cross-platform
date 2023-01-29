package com.codehelp.forum.api

import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@Target(AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@MustBeDocumented
@RestController
@RequestMapping(name = "auth", value = ["/api"], produces = [MediaType.APPLICATION_JSON_VALUE])
annotation class RestControllerAuth()
