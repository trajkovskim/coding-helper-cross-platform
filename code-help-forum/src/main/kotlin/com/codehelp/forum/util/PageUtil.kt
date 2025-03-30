package com.codehelp.forum.util

import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.util.CollectionUtils

/**
 * Page utils.
 */
object PageUtil {
  fun createPageRequest(pageNumber: Int, pageSize: Int, sortBy: List<String>): Pageable {

    if(CollectionUtils.isEmpty(sortBy)) {
      return PageRequest.of(pageNumber, pageSize)
    }

    val orders = sortBy.stream().map { sorter: String ->
      val x: Array<String?> = sorter.split("=").dropLastWhile { it.isEmpty() }.toTypedArray()
      if (x.size > 1 && x[1] == "desc") Sort.Order.desc(x[0]!!) else Sort.Order.asc(
        x[0]!!
      )
    }.toList()

    val sort = Sort.by(orders)

    return PageRequest.of(pageNumber, pageSize, sort)
  }
}
