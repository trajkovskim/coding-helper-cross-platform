package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.CategoryMapper;
import mk.com.codehelp.core.rest.api.CategoriesApi;
import mk.com.codehelp.core.rest.model.CategoriesResponse;
import mk.com.codehelp.core.service.service.CategoryService;
import org.springframework.http.ResponseEntity;

import java.util.List;

@CodingHelperController
@RequiredArgsConstructor
public class CategoryController implements CategoriesApi {

  private final CategoryService categoryService;
  private final CategoryMapper categoryConverter;

  @Override
  public ResponseEntity<CategoriesResponse> getCategories() {
    List<mk.com.codehelp.core.domain.model.Category> categories = categoryService.findALl();
    CategoriesResponse response = categoryConverter.toResponse(categories);
    return ResponseEntity.ok(response);
  }
}
