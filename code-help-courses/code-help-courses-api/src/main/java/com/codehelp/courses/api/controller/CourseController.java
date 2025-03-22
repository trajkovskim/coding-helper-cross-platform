package com.codehelp.courses.api.controller;

import com.codehelp.courses.api.factory.CoursesResponseFactory;
import com.codehelp.courses.api.mapper.CourseRestMapper;
import com.codehelp.courses.core.CourseService;
import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.CourseFiltersDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import lombok.RequiredArgsConstructor;
import mk.com.codehelp.courses.rest.api.CourseApi;
import mk.com.codehelp.courses.rest.model.CourseFilters;
import mk.com.codehelp.courses.rest.model.CourseResponse;
import mk.com.codehelp.courses.rest.model.CoursesResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class CourseController implements CourseApi {

  private final CourseService courseService;
  private final CoursesResponseFactory coursesResponseFactory;
  private final CourseRestMapper courseRestMapper;

  @Override
  public ResponseEntity<CourseResponse> getCourse(Long id, String acceptLanguage) {

    CourseDto course = courseService.getCourse(id);

    CourseResponse courseResponse = courseRestMapper.toRest(course);

    return ResponseEntity.ok(courseResponse);
  }

  @Override
  public ResponseEntity<CoursesResponse> searchCourses(
      CourseFilters courseFilters, String acceptLanguage, Integer page, Integer size, List<String> sortBy) {

    CourseFiltersDto courseFiltersDto = courseRestMapper.fromRest(courseFilters);

    PageInfoDto<CourseDto> coursesPageInfoDto = courseService.getCourses(courseFiltersDto, page, size, sortBy);

    CoursesResponse coursesResponse =
        coursesResponseFactory.createCoursesResponse(coursesPageInfoDto, courseFilters, page, size, sortBy);

    return ResponseEntity.ok(coursesResponse);
  }
}
