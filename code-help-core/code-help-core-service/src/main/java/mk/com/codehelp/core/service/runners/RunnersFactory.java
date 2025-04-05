package mk.com.codehelp.core.service.runners;

import java.util.List;

import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.service.config.Compilers;
import mk.com.codehelp.core.service.exceptions.CompilerNotFoundException;

@Component
@RequiredArgsConstructor
public class RunnersFactory {

  private final List<Runner> runners;
  private final Compilers compilers;

  public Runner getRunner(String language) {

    Compilers.SingleCompiler compiler = compilers.getCompilers().getOrDefault(language, null);

    return runners.stream()
        .filter(runner -> runner.getCompiler().equals(compiler))
        .findFirst()
        .orElseThrow(() -> new CompilerNotFoundException(language));
  }
}
