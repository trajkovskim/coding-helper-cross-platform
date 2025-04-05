package mk.com.codehelp.core.service.runners;

import mk.com.codehelp.core.service.config.Compilers;

public interface Runner {

  Compilers.SingleCompiler getCompiler();

  Process run(String code, String input);
}
