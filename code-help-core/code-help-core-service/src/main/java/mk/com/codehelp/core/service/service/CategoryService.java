package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.value.CategoryValue;

import java.util.List;

public interface CategoryService {

  Category getOrCreate(String name, String description);

  List<CategoryValue> findALl();

  Category findById(Long id);

  Category findByName(String name);

  void create(Category category);

  void update(Long id, Category category);

  void delete(Long id);
}
