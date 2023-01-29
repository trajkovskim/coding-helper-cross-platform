package mk.com.codehelp.core.service.exceptions;

public class ContestStatusNotOpenException extends RuntimeException {
  public ContestStatusNotOpenException(Long id) {
    super("Contest id: " + id + " doesn't have status OPEN");
  }
}
