package com.codehelp.courses.api.factory;

import com.codehelp.courses.api.mapper.CourseRestMapper;
import com.codehelp.courses.api.mapper.PageInfoMappingContext;
import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import lombok.RequiredArgsConstructor;
import mk.com.codehelp.courses.rest.model.CourseFilters;
import mk.com.codehelp.courses.rest.model.CoursesResponse;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class CoursesResponseFactory {

  private final CourseRestMapper courseRestMapper;

  public CoursesResponse createCoursesResponse(
      PageInfoDto<CourseDto> coursesPageInfoDto,
      CourseFilters courseFilters,
      Integer page,
      Integer size,
      List<String> sortBy) {

    PageInfoMappingContext.PageInfoMappingContextBuilder<CourseFilters> builder = PageInfoMappingContext.builder();
    PageInfoMappingContext<CourseFilters> pageInfoMappingContext = builder
        .filters(courseFilters)
        .page(page)
        .size(size)
        .sortBy(sortBy)
        .build();

    return courseRestMapper.toRest(coursesPageInfoDto, pageInfoMappingContext);
  }
}
