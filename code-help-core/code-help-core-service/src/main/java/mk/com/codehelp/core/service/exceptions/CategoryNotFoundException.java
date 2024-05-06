package mk.com.codehelp.core.service.exceptions;

public class CategoryNotFoundException extends RuntimeException {
  public CategoryNotFoundException(Long id) {
    super(String.format("Category with id: %d could not be found", id));
  }

  public CategoryNotFoundException(String name) {
    super(String.format("Category %s could not be found", name));
  }
}
