package com.codehelp.forum.util

import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

/**
 * Page utils.
 */
object PageUtil {
  fun createPageRequest(pageNumber: Int, pageSize: Int, sortBy: List<String>): Pageable {
    val orders = sortBy.stream().map { sorter: String ->
      val x: Array<String?> = sorter.split("=".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
      if (x[1] != null && x[1] == "desc") Sort.Order.desc(x[0]!!) else Sort.Order.asc(
        x[0]!!
      )
    }.toList()

    val sort = Sort.by(orders)

    return PageRequest.of(pageNumber, pageSize, sort)
  }
}
