package com.codehelp.courses.api.mapper;

import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.CourseFiltersDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import mk.com.codehelp.courses.rest.model.CourseFilters;
import mk.com.codehelp.courses.rest.model.CourseResponse;
import mk.com.codehelp.courses.rest.model.CoursesResponse;
import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(uses = {LinksMapper.class})
public interface CourseRestMapper {

  @Mapping(target = "info", source = "pageInfoDto")
  @Mapping(target = "courses", source = "pageInfoDto.items")
  @Mapping(target = "links", ignore = true)
  CoursesResponse toRest(PageInfoDto<CourseDto> pageInfoDto, @Context PageInfoMappingContext<CourseFilters> pageInfoMappingContext);

  CourseResponse toRest(CourseDto courseDto);

  CourseFiltersDto fromRest(CourseFilters courseFilters);
}
