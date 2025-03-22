package com.codehelp.courses.api.factory;

import com.codehelp.courses.core.dto.PageInfoDto;
import mk.com.codehelp.courses.rest.model.Link;
import mk.com.codehelp.courses.rest.model.PaginationLinks;
import mk.com.codehelp.courses.rest.model.SelfLink;
import org.springframework.stereotype.Component;

import java.util.function.BiFunction;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;

@Component
public class LinksFactory {

  public Link getSelfRelLink(Object invokableValue) {

    String href = linkTo(invokableValue).withSelfRel().getHref();

    return new Link().href(href);
  }

  public SelfLink createSelfLink(Object invokableValue) {

    Link link = getSelfRelLink(invokableValue);

    return new SelfLink().self(link);
  }

  public <T> PaginationLinks createPaginationLinks(
      PageInfoDto<T> pageInfoDto, BiFunction<Integer, Integer, Object> pageInvokableValue) {

    Link self = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.getPageNumber(), pageInfoDto.getPageSize()));
    Link first = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.getFirstPage(), pageInfoDto.getPageSize()));
    Link last = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.getPageNumber(), pageInfoDto.getPageSize()));

    PaginationLinks paginationLinks = new PaginationLinks().self(self).first(first).last(last);

    if (pageInfoDto.hasNextPage()) {

      Link next = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.getNextPage(), pageInfoDto.getPageSize()));
      paginationLinks.setNext(next);
    }

    if (pageInfoDto.hasPrevPage()) {

      Link prev = getSelfRelLink(pageInvokableValue.apply(pageInfoDto.getPrevPage(), pageInfoDto.getPageSize()));
      paginationLinks.setPrev(prev);
    }

    return paginationLinks;
  }
}
