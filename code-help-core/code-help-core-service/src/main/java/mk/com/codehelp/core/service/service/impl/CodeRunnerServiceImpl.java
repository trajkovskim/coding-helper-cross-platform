package mk.com.codehelp.core.service.service.impl;

import jakarta.annotation.Nonnull;
import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.service.config.Compilers;
import mk.com.codehelp.core.service.dto.ProblemDto;
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
  public String runTestCases(List<Problem.TestCase> testCases, String code, String language)
      throws IOException, InterruptedException {
    int n = testCases.size();
    int i = 1;

    for (final Problem.TestCase testCase : testCases) {

      final String output = this.runCode(testCase.getIn(), code, language);

      final String expectedOutput = testCase.getOut();

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

    ProblemDto problem = problemService.getProblem(problemId, language);

    return createCode(language, code, problem.getRunnerCode().getCode());
  }

  @Override
  public String createCode(String language, String code, String runnerCode) {
    if (!compilers.getCompilers().containsKey(language)) {
      throw new CompilerNotFoundException(language);
    }

    return code + "\n" + runnerCode;
  }
}
