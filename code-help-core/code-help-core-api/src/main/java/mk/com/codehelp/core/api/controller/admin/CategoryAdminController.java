package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.admin.AdminCategoryMapper;
import mk.com.codehelp.core.rest.admin.api.CategoryApi;
import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.CategoryResponse;
import mk.com.codehelp.core.service.service.CategoryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class CategoryAdminController implements CategoryApi {

    private final CategoryService categoryService;
    private final AdminCategoryMapper categoryConverter;

    @Override
    public ResponseEntity<Void> createCategory(Category category) {

        categoryService.create(categoryConverter.convert(category));
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @Override
    public ResponseEntity<CategoryResponse> getAllCategories() {

        CategoryResponse response = categoryConverter.convert(categoryService.findALl());

        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<Void> updateCategory(String name, Category category) {

        mk.com.codehelp.core.domain.model.Category convert = categoryConverter.convert(category);

        categoryService.update(name, convert);

        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<Void> deleteCategory(String name) {

        categoryService.delete(name);

        return ResponseEntity.noContent().build();
    }
}
