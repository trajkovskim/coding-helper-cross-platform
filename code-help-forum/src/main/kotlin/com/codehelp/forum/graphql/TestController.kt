//package com.codehelp.forum.api
//
//import org.springframework.graphql.data.method.annotation.Argument
//import org.springframework.graphql.data.method.annotation.QueryMapping
//import org.springframework.web.bind.annotation.RestController
//
//@RestController
//class TestController {
////    @SchemaMapping("/")
//
//    val list = listOf(
//        Book("1", "Hello!"),
//        Book("2", "Bonjour!"),
//        Book("3", "Privet!"),
//    )
//
//
//    @QueryMapping
//    fun allBooks(): List<Book> = list
//
//    @QueryMapping
//    fun findOne(@Argument id: String) = list.find { book -> book.id == id }
//
//}
//
//data class Book(val id: String?, val title: String)
