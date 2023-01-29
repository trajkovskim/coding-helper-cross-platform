package mk.com.codehelp.core.service.exceptions;

public class CategoryNotFoundException extends RuntimeException {
  public CategoryNotFoundException(String name) {
    super(String.format("Category %s could not be found", name));
  }
}
