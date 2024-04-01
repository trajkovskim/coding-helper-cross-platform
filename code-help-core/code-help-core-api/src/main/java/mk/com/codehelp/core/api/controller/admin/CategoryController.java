package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.controller.CodingHelperController;
import mk.com.codehelp.core.api.mappers.admin.CategoryMapper;
import mk.com.codehelp.core.rest.admin.api.AdminApi;
import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.CategoryResponse;
import mk.com.codehelp.core.service.service.CategoryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@CodingHelperController
@RequiredArgsConstructor
public class CategoryController implements AdminApi {

  private final CategoryService categoryService;
  private final CategoryMapper categoryConverter;

  @Override
  public ResponseEntity<Void> createCategory(String authorization, Category category) {

    categoryService.create(categoryConverter.convert(category));
    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  @Override
  public ResponseEntity<CategoryResponse> getAllCategories(String authorization) {

    CategoryResponse response = categoryConverter.convert(categoryService.findALl());

    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<Void> updateCategory(String authorization, String name, Category category) {

    mk.com.codehelp.core.domain.model.Category convert = categoryConverter.convert(category);

    categoryService.update(name, convert);

    return ResponseEntity.noContent().build();
  }
}
