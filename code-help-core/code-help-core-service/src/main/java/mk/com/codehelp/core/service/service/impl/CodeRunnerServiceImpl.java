package mk.com.codehelp.core.service.service.impl;

import jakarta.annotation.Nonnull;
import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.service.config.Compilers;
import mk.com.codehelp.core.service.exceptions.CompilerNotFoundException;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import mk.com.codehelp.core.service.service.ProblemService;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CodeRunnerServiceImpl implements CodeRunnerService {
  private final Compilers compilers;
  private final ProblemService problemService;

  @Override
  public String runTestCases(List<mk.com.codehelp.core.domain.model.File> testCases, String code, String language)
      throws IOException, InterruptedException {
    int n = testCases.size();
    int i = 1;

    Map<String, mk.com.codehelp.core.domain.model.File> testCasesByFileName = testCases.stream()
        .collect(Collectors.toMap(mk.com.codehelp.core.domain.model.File::getName, file -> file));

    for (final mk.com.codehelp.core.domain.model.File inputTestCase : testCasesByFileName.values()) {
      if (inputTestCase.getName().startsWith("OUT")) {
        continue;
      }

      String input = new String(inputTestCase.getData(), StandardCharsets.UTF_8);
      final String output = this.runCode(input, code, language);

      mk.com.codehelp.core.domain.model.File outputTestCase =
          testCasesByFileName.get(inputTestCase.getName().replaceFirst("IN", "OUT"));
      final String expectedOutput = new String(outputTestCase.getData(), StandardCharsets.UTF_8);

      if (!output.equals(expectedOutput)) {
        return String.format("Test case %d of %d failed\nOutput: %s\nExpected: %s", i, n, output, expectedOutput);
      }
      ++i;
    }
    return "All test cases passed! Well done!";
  }

  @Override
  public String runCode(@Nonnull String input, String code, String language) throws IOException, InterruptedException {
    if (!compilers.getCompilers().containsKey(language)) {
      throw new CompilerNotFoundException(language);
    }

    final Compilers.SingleCompiler singleCompiler = compilers.getCompilers().get(language);
    final String compiler = singleCompiler.getCompiler();
    final String ext = singleCompiler.getExt();

    String codeFilename = UUID.randomUUID() + ext;
    PrintWriter pw = new PrintWriter(codeFilename);
    pw.println(code);
    pw.close();

    List<String> args = new ArrayList<>(Arrays.stream(input.split("\n")).toList());
    args.add(0, compiler);
    args.add(1, codeFilename);

    Process process = new ProcessBuilder().command(args).start();
    process.waitFor(10, TimeUnit.SECONDS);

    String error = process.errorReader().lines().collect(Collectors.joining());
    String output = process.inputReader().lines().collect(Collectors.joining());

    process.destroy();

    new File(codeFilename).delete();

    return output.isEmpty() ? error : output;
  }

  @Override
  public String runCodeWithTestCases(Long problemId, String language, String code)
      throws IOException, InterruptedException {
    final String mergedCode = this.createCode(problemId, language, code);
    final Problem problem = problemService.findById(problemId);

    return runTestCases(problem.getTestCases(), mergedCode, language);
  }

  @Override
  public String createCode(Long problemId, String language, String code) {
    if (!compilers.getCompilers().containsKey(language)) {
      throw new CompilerNotFoundException(language);
    }

    final Problem problem = problemService.findById(problemId);
    final String runnerCode = new String(problem.getRunnerCode().getData(), StandardCharsets.UTF_8);

    return code + "\n" + runnerCode;
  }
}
