package mk.com.codehelp.core.api.mappers.admin;

import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.CategoryRequest;
import mk.com.codehelp.core.rest.admin.model.CategoryResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.stream.Collectors;

@Mapper
public interface AdminCategoryMapper {

  default CategoryResponse convert(List<mk.com.codehelp.core.domain.model.Category> problems) {

    return new CategoryResponse().categories(
        problems.stream().map(this::convert).collect(Collectors.toList()));
  }

  Category convert(mk.com.codehelp.core.domain.model.Category category);

  @Mapping(target = "id", ignore = true)
  mk.com.codehelp.core.domain.model.Category convert(CategoryRequest category);
}
