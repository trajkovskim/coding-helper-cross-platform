package mk.com.codehelp.core.service.exceptions;

public class UserAlreadyExistsException extends RuntimeException {
  public UserAlreadyExistsException(String email) {
    super(String.format("User %s already exists", email));
  }
}
