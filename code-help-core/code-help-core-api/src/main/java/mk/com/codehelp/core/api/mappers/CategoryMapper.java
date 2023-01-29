package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.rest.model.CategoriesResponse;
import mk.com.codehelp.core.rest.model.Category;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface CategoryMapper {

  Category convertCategory(mk.com.codehelp.core.domain.model.Category category);

  mk.com.codehelp.core.domain.model.Category convertCategory(Category category);

  List<Category> convertListOfCategoryToRest(List<mk.com.codehelp.core.domain.model.Category> categories);

  List<mk.com.codehelp.core.domain.model.Category> convertListOfCategory(List<Category> categories);

  default CategoriesResponse toResponse(List<mk.com.codehelp.core.domain.model.Category> categories) {
    List<Category> entries = convertListOfCategoryToRest(categories);
    return new CategoriesResponse().categories(entries);
  }

}
