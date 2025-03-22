package com.codehelp.courses.core.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CourseModuleDto {

  private String title;
  private String description;
}
