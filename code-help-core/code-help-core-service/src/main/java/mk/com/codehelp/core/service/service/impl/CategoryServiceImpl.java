package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.service.exceptions.CategoryNotFoundException;
import mk.com.codehelp.core.service.service.CategoryService;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

  private final CategoryRepository categoryRepository;

  @Override
  public List<Category> findALl() {
    return this.categoryRepository.findAll();
  }

  @Override
  public Category findById(Long id) {
    return categoryRepository.findById(id)
        .orElseThrow(() -> new CategoryNotFoundException(id));
  }

  @Override
  public Category findByName(String name) {
    return categoryRepository.findByName(name)
        .orElseThrow(() -> new CategoryNotFoundException(name));
  }

  @Override
  public void create(Category category) {
    categoryRepository.save(category);
  }

  @Override
  public void update(Long id, Category category) {

    Category oldCategory = this.findById(id);
    oldCategory.setName(category.getName());

    categoryRepository.save(oldCategory);
  }

  @Override
  public void delete(Long id) {
      final var category = this.findById(id);
      categoryRepository.delete(category);
  }
}
