package com.codehelp.forum.factory

import com.codehelp.forum.generated.rest.model.LinkDto
import com.codehelp.forum.generated.rest.model.PaginationLinksDto
import com.codehelp.forum.generated.rest.model.SelfLinkDto
import com.codehelp.forum.model.dto.PageInfoDto
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder
import org.springframework.stereotype.Component
import java.util.function.BiFunction

@Component
class LinksFactory {
  fun getSelfRelLink(invokableValue: Any): LinkDto {
    val href = WebMvcLinkBuilder.linkTo(invokableValue).withSelfRel().href

    return LinkDto().href(href)
  }

  fun createSelfLink(invokableValue: Any): SelfLinkDto = SelfLinkDto().self(getSelfRelLink(invokableValue))

  fun <T> createPaginationLinks(
    pageInfoDto: PageInfoDto<T>, pageInvokableValue: BiFunction<Int, Int, Any>
  ): PaginationLinksDto {
    val self = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.pageNumber, pageInfoDto.pageSize))
    val first = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.firstPage, pageInfoDto.pageSize))
    val last = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.pageNumber, pageInfoDto.pageSize))

    val paginationLinks = PaginationLinksDto().self(self).first(first).last(last)

    if (pageInfoDto.hasNextPage()) {
      val next = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.nextPage!!, pageInfoDto.pageSize))
      paginationLinks.next = next
    }

    if (pageInfoDto.hasPrevPage()) {
      val prev = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.prevPage!!, pageInfoDto.pageSize))
      paginationLinks.prev = prev
    }

    return paginationLinks
  }
}