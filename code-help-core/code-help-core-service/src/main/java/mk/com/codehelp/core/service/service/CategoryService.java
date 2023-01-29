package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Category;

import java.util.List;

public interface CategoryService {
  List<Category> findALl();

  Category findById(String name);

  void create(Category category);
}
