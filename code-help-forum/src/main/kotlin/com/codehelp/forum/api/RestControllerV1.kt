package com.codehelp.forum.api

import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.lang.annotation.*


@Target(AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
@MustBeDocumented
@RestController
@RequestMapping(name = "v1", value = ["/api/v1"], produces = [MediaType.APPLICATION_JSON_VALUE])
annotation class RestControllerV1()
