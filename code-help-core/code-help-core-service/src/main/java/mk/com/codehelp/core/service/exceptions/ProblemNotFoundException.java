package mk.com.codehelp.core.service.exceptions;

public class ProblemNotFoundException extends RuntimeException {

  public ProblemNotFoundException(Long id) {
    super(String.format("Problem %d could not be found", id));
  }
}
