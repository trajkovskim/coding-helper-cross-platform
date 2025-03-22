package com.codehelp.courses.core;

import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.CourseFiltersDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import com.codehelp.courses.core.spi.PersistenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseService {

  private final PersistenceService persistenceService;

  public PageInfoDto<CourseDto> getCourses(
      CourseFiltersDto courseFilters,
      Integer pageNumber,
      Integer pageSize,
      List<String> sortBy) {

    return persistenceService.findAllCourses(courseFilters, pageNumber, pageSize, sortBy);
  }

  public CourseDto getCourse(Long id) {

    return persistenceService.findCourseById(id).orElseThrow();
  }
}
