package mk.com.codehelp.core.api.controller.converter;

import mk.com.codehelp.core.rest.model.Category;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

@Component
public class CategoryConverter implements Converter<String, Category> {
    @Override
    public Category convert(String category) {
        return new Category().name(category);
    }
}
