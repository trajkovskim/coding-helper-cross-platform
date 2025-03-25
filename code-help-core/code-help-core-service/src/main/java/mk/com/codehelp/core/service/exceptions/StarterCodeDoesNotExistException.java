package mk.com.codehelp.core.service.exceptions;

public class StarterCodeDoesNotExistException extends RuntimeException {

  public StarterCodeDoesNotExistException(Long problemId, String language) {
    super("Starter code with language " + language + " in problem " + problemId + " does not exist");
  }
}
