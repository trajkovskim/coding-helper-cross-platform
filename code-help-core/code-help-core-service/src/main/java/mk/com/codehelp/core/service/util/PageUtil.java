package mk.com.codehelp.core.service.util;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.util.CollectionUtils;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.service.dto.PageInfoDto;

/**
 * Page utils.
 */
public class PageUtil {

  public static Pageable createPageRequest(Integer pageNumber, Integer pageSize, List<String> sortBy) {

    if(CollectionUtils.isEmpty(sortBy)) {
      return PageRequest.of(pageNumber, pageSize);
    }

    List<Sort.Order> orders = sortBy.stream().map(sorter -> {
      final String[] x = sorter.split("=");
      return x[1] != null && x[1].equals("desc") ? Sort.Order.desc(x[0]) : Sort.Order.asc(x[0]);
    }).toList();

    final Sort sort = Sort.by(orders);

    return PageRequest.of(pageNumber, pageSize, sort);
  }

  public static <T> PageInfoDto<T> createPageInfo(Page<T> page, Pageable pageable) {

    return createPageInfo(page, pageable, value -> value);
  }

  public static <T, K> PageInfoDto<K> createPageInfo(Page<T> page, Pageable pageable, Function<T,K> mapper) {

    Set<K> items = page.stream().parallel().map(mapper).collect(Collectors.toSet());
    return PageInfoDto.<K>builder()
      .items(items)
      .pageNumber(pageable.getPageNumber())
      .pageSize(page.getSize())
      .totalPages(page.getTotalPages())
      .totalElements(page.getTotalElements())
      .build();
  }
}
