package mk.com.codehelp.core.service.util;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.util.CollectionUtils;

import java.util.List;

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
}
