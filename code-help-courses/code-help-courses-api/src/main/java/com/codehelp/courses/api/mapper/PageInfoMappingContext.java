package com.codehelp.courses.api.mapper;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class PageInfoMappingContext<F> {

  private F filters;
  private Integer page;
  private Integer size;
  private List<String> sortBy;
}
