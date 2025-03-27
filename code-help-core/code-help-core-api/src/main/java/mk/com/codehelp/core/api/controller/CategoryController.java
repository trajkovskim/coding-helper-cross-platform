package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.CategoryMapper;
import mk.com.codehelp.core.rest.api.CategoryApi;
import mk.com.codehelp.core.rest.model.CategoriesResponse;
import mk.com.codehelp.core.rest.model.Category;
import mk.com.codehelp.core.service.service.CategoryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class CategoryController implements CategoryApi {

  private final CategoryService categoryService;
  private final CategoryMapper categoryConverter;

  @Override
  public ResponseEntity<CategoriesResponse> getCategories() {
    List<mk.com.codehelp.core.domain.model.Category> categories = categoryService.findALl();
    List<Category> categoriesRest = categoryConverter.convert(categories);

    CategoriesResponse response = new CategoriesResponse().categories(categoriesRest);

    return ResponseEntity.ok(response);
  }
}
