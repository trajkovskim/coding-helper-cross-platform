package com.codehelp.courses.core.spi;

import com.codehelp.courses.core.dto.CourseFiltersDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import com.codehelp.courses.core.dto.CourseDto;

import java.util.List;
import java.util.Optional;

public interface PersistenceService {

  PageInfoDto<CourseDto> findAllCourses(
      CourseFiltersDto courseFiltersDto, Integer pageNumber, Integer pageSize, List<String> sortBy);

  Optional<CourseDto> findCourseById(Long id);
}
