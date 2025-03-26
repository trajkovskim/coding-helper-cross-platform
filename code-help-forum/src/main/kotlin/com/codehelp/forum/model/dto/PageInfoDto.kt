package com.codehelp.forum.model.dto

import lombok.Builder
import lombok.Value
import java.util.*

@Builder
@Value
class PageInfoDto<T> {
  var totalElements: Long = 0
  var totalPages: Int = 0
  var pageSize: Int = 0
  var pageNumber: Int = 0
  var items: Collection<T> = Collections.emptyList()

  val firstPage: Int
    get() = 0

  val lastPage: Int
    get() = totalPages

  val nextPage: Int?
    get() {
      if (!hasNextPage()) {
        return null
      }

      return pageNumber + 1
    }

  val prevPage: Int?
    get() {
      if (!hasPrevPage()) {
        return null
      }

      return pageNumber - 1
    }

  fun hasNextPage(): Boolean {
    return pageNumber < lastPage
  }

  fun hasPrevPage(): Boolean {
    return pageNumber > firstPage
  }
}