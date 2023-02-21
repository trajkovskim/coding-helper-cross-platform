package mk.com.codehelp.core.service.exceptions;

public class CompilerNotFoundException extends RuntimeException {
  public CompilerNotFoundException(String language) {
    super(String.format("Compiler for %s could not be found", language));
  }

}
