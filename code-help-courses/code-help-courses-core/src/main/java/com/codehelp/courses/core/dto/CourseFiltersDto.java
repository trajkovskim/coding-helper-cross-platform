package com.codehelp.courses.core.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CourseFiltersDto {

  private String name;
  private String category;
}
