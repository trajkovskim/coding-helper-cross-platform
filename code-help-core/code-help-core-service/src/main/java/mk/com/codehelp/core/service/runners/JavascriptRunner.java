package mk.com.codehelp.core.service.runners;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import mk.com.codehelp.core.service.config.Compilers;

public class JavascriptRunner implements Runner {

  @Override
  public String run(Compilers.SingleCompiler compilerProperties) {

    final String compiler = compilerProperties.getCompiler();
    final String ext = compilerProperties.getExt();

//    List<String> args = new ArrayList<>(Arrays.stream(input.split("\n")).toList());
//    args.add(0, compiler);
//    args.add(1, codeFilename);
//
//    Process process = new ProcessBuilder().command(args).start();
//    process.waitFor(10, TimeUnit.SECONDS);
    return null;
  }
}
