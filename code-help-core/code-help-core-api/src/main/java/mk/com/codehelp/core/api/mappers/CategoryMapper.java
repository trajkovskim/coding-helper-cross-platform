package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.value.CategoryValue;
import mk.com.codehelp.core.rest.model.Category;

import java.util.Collection;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface CategoryMapper {

  Category convert(mk.com.codehelp.core.domain.model.Category category);

  List<Category> convert(Collection<CategoryValue> categories);
}
