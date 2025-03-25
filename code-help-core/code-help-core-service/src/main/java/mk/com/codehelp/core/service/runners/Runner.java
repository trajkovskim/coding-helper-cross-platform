package mk.com.codehelp.core.service.runners;

import mk.com.codehelp.core.service.config.Compilers;

public interface Runner {

  String run(Compilers.SingleCompiler compiler);
}
