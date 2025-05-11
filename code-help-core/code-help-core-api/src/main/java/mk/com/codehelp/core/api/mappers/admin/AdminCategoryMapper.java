package mk.com.codehelp.core.api.mappers.admin;

import mk.com.codehelp.core.domain.model.value.CategoryValue;
import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.CategoryRequest;
import mk.com.codehelp.core.rest.admin.model.CategoryResponse;

import java.util.Collection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper
public interface AdminCategoryMapper {

  default CategoryResponse convert(Collection<CategoryValue> categories) {
    return new CategoryResponse().categories(convertPrivate(categories));
  }

  List<Category> convertPrivate(Collection<CategoryValue> categories);

  Category convert(mk.com.codehelp.core.domain.model.Category category);

  @Mapping(target = "id", ignore = true)
  mk.com.codehelp.core.domain.model.Category convert(CategoryRequest category);
}
