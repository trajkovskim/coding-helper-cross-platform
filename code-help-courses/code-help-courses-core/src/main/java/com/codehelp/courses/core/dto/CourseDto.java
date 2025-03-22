package com.codehelp.courses.core.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CourseDto {

  private Long id;
  private String title;
  private String description;
  private String level;
  private String category;
  private String subCategory;

  private List<CourseModuleDto> modules;
}
