package mk.com.codehelp.core.service.exceptions;

public class InvalidFileException extends RuntimeException {
  public InvalidFileException() {
    super("Invalid image was sent");
  }
}
