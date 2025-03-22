package com.codehelp.courses.persistence.util;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Page utils.
 */
@Component
public class PageUtil {

  public Pageable createPageRequest(Integer pageNumber, Integer pageSize, List<String> sortBy) {

    List<Sort.Order> orders = sortBy.stream().map(sorter -> {
      final String[] x = sorter.split("=");
      return x[1] != null && x[1].equals("desc") ? Sort.Order.desc(x[0]) : Sort.Order.asc(x[0]);
    }).toList();

    final Sort sort = Sort.by(orders);

    return PageRequest.of(pageNumber, pageSize, sort);
  }
}
