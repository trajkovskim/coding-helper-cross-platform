package mk.com.codehelp.core.service.runners;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.springframework.stereotype.Component;

import lombok.SneakyThrows;

import mk.com.codehelp.core.service.config.Compilers;
import mk.com.codehelp.core.service.util.CodeUtil;

@Component
public class JavaRunner implements Runner {

  private final Compilers.SingleCompiler java;
  private final CodeUtil codeUtil;
  private static final String language = "java";

  public JavaRunner(Compilers compilers, CodeUtil codeUtil) {
    this.java = compilers.getCompilers().get(language);
    this.codeUtil = codeUtil;
  }

  @Override
  public Compilers.SingleCompiler getCompiler() {
    return java;
  }

  @SneakyThrows
  @Override
  public Process run(String code, String input) {

    Compilers.SingleCompiler compiler = getCompiler();

    File tempCodeFile = codeUtil.createTempCodeFile(code, compiler.getExt());
    List<String> args = new ArrayList<>(Arrays.stream(input.split("\n")).toList());
    args.add(0, compiler.getCompiler());
    args.add(1, tempCodeFile.getAbsolutePath());

    Process process = new ProcessBuilder().command(args).start();
    process.waitFor(10, TimeUnit.SECONDS);

    codeUtil.deleteFile(tempCodeFile);

    return process;
  }
}
