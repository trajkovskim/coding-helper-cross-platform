package com.codehelp.courses.core.dto;

import lombok.Builder;
import lombok.Value;

import java.util.Collection;

@Builder
@Value
public class PageInfoDto<T> {

  long totalElements;
  int totalPages;
  int pageSize;
  int pageNumber;
  Collection<T> items;

  public int getFirstPage() {
    return 0;
  }

  public int getLastPage() {
    return getTotalPages();
  }

  public Integer getNextPage() {

    if(!hasNextPage()) {
      return null;
    }

    return pageNumber + 1;
  }

  public Integer getPrevPage() {

    if(!hasPrevPage()) {
      return null;
    }

    return pageNumber - 1;
  }

  public boolean hasNextPage() {
    return pageNumber < getLastPage();
  }

  public boolean hasPrevPage() {
    return pageNumber > getFirstPage();
  }
}
