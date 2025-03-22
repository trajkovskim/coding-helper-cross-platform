package com.codehelp.courses.persistence.adapter;

import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.core.dto.CourseFiltersDto;
import com.codehelp.courses.core.dto.PageInfoDto;
import com.codehelp.courses.core.spi.PersistenceService;
import com.codehelp.courses.persistence.entity.Course;
import com.codehelp.courses.persistence.mapper.CourseEntityMapper;
import com.codehelp.courses.persistence.repository.CourseRepository;
import com.codehelp.courses.persistence.util.PageUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CoursesPersistenceAdapter implements PersistenceService {

  private final CourseEntityMapper courseEntityMapper;
  private final CourseRepository courseRepository;

  private final PageUtil pageUtil;

  @Override
  public PageInfoDto<CourseDto> findAllCourses(
      CourseFiltersDto courseFiltersDto, Integer pageNumber, Integer pageSize, List<String> sortBy) {

    Pageable pageRequest = pageUtil.createPageRequest(pageNumber, pageSize, sortBy);

    Page<Course> coursePage = courseRepository.findAll(pageRequest);

    List<CourseDto> courseDtoStream = coursePage.get().map(courseEntityMapper::fromEntity).toList();

    return PageInfoDto.<CourseDto>builder()
        .items(courseDtoStream)
        .totalPages(coursePage.getTotalPages())
        .totalElements(coursePage.getTotalElements())
        .pageNumber(pageNumber)
        .pageSize(pageSize)
        .build();
  }

  @Override
  public Optional<CourseDto> findCourseById(Long id) {

    return courseRepository.findById(id).map(courseEntityMapper::fromEntity);
  }
}
