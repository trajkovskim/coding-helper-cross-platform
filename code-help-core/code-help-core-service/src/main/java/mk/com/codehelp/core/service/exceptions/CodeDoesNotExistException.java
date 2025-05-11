package mk.com.codehelp.core.service.exceptions;

public class CodeDoesNotExistException extends RuntimeException {

  public CodeDoesNotExistException(Long problemId, String language) {
    super("Starter code with language " + language + " in problem " + problemId + " does not exist");
  }
}
