package com.codehelp.courses.api.mapper;

import com.codehelp.courses.api.controller.CourseController;
import com.codehelp.courses.api.factory.LinksFactory;
import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import lombok.RequiredArgsConstructor;

import mk.com.codehelp.courses.rest.model.*;

import org.mapstruct.AfterMapping;
import org.mapstruct.Context;
import org.mapstruct.MappingTarget;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@Component
@RequiredArgsConstructor
public class LinksMapper {

  private final LinksFactory linksFactory;

  @AfterMapping
  public void addLinks(
      PageInfoDto<CourseDto> coursePageInfoDto,
      @MappingTarget CoursesResponse coursesResponse,
      @Context PageInfoMappingContext<CourseFilters> pageInfoMappingContext) {

    String acceptLanguage = LocaleContextHolder.getLocale().toString();

    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
        coursePageInfoDto,
        (pageNumber, pageSize) ->
            methodOn(CourseController.class)
                .searchCourses(
                    pageInfoMappingContext.getFilters(),
                    acceptLanguage,
                    pageNumber,
                    pageSize,
                    pageInfoMappingContext.getSortBy()));

    coursesResponse.setLinks(paginationLinks);
  }

  public void addLinks(CourseDto courseDto, @MappingTarget CourseResponse courseResponse) {

    String acceptLanguage = LocaleContextHolder.getLocale().toString();

    SelfLink selfLink = linksFactory
        .createSelfLink(methodOn(CourseController.class).getCourse(courseDto.getId(), acceptLanguage));

    courseResponse.setLinks(selfLink);
  }
}
