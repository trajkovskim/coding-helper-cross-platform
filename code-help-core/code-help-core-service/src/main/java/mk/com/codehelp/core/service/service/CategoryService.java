package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Category;

import java.util.List;

public interface CategoryService {

  Category getOrCreate(String name);

  List<Category> findALl();

  Category findById(Long id);

  Category findByName(String name);

  void create(Category category);

  void update(Long id, Category category);

  void delete(Long id);
}
