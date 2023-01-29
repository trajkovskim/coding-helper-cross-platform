package mk.com.codehelp.core.service.exceptions;

public class ContestNotFoundException extends RuntimeException {
  public ContestNotFoundException(Long id) {
    super("Contest with id: " + id + " not found");
  }
}
