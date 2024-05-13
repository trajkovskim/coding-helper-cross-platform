package mk.com.codehelp.core.api.controller.converter;

import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.CategoryRequest;
import org.springframework.core.convert.converter.Converter;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;

@Component
public class CategoryConverter implements Converter<String, CategoryRequest> {

    @Override
    public CategoryRequest convert(@NonNull String category) {
        return new CategoryRequest().name(category);
    }
}
