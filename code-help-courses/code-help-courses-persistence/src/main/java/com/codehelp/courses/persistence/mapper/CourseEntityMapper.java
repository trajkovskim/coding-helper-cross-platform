package com.codehelp.courses.persistence.mapper;

import com.codehelp.courses.core.dto.CourseDto;
import com.codehelp.courses.persistence.entity.Course;
import org.mapstruct.Mapper;

@Mapper
public interface CourseEntityMapper {

  CourseDto fromEntity(Course course);

  Course toEntity(CourseDto course);
}
