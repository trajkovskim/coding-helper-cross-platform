package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.admin.AdminCategoryMapper;
import mk.com.codehelp.core.rest.admin.api.CategoryApi;
import mk.com.codehelp.core.rest.admin.model.*;

import org.springframework.web.bind.annotation.RestController;

import mk.com.codehelp.core.service.service.CategoryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@RestController
@RequiredArgsConstructor
public class CategoryAdminController implements CategoryApi {

  private final CategoryService categoryService;
  private final AdminCategoryMapper categoryConverter;

  @Override
  public ResponseEntity<CreatedResponse> createCategory(CategoryRequest category) {

    categoryService.create(categoryConverter.convert(category));

    CreatedResponse createdResponse = new CreatedResponse();

    return ResponseEntity.status(HttpStatus.CREATED)
        .body(createdResponse);
  }

  @Override
  public ResponseEntity<CategoryResponse> getAllCategories() {

    CategoryResponse response = categoryConverter.convert(categoryService.findALl());

    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<Void> updateCategory(Long id, CategoryRequest category) {

    mk.com.codehelp.core.domain.model.Category convert = categoryConverter.convert(category);

    categoryService.update(id, convert);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> deleteCategory(Long id) {

    categoryService.delete(id);

    return ResponseEntity.noContent().build();
  }
}
