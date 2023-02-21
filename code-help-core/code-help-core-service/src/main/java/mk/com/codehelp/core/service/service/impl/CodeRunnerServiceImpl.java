package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.service.config.Compilers;
import mk.com.codehelp.core.service.exceptions.CompilerNotFoundException;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CodeRunnerServiceImpl implements CodeRunnerService {
  private final Compilers compilers;

  @Override
  public String runTestCases(File[] testCases, String code, String language) throws IOException, InterruptedException {
    int n = testCases.length;
    int i = 1;
    for (File testCase : testCases) {
      // Read IN file
      String inFilePath = testCase.getPath();
      var input = new BufferedReader(new FileReader(inFilePath))
          .lines().collect(Collectors.joining("\n"));

      var output = this.runCode(input, code, language);

      // Read OUT file
      String outFilePath = testCase.getPath().replace("IN", "OUT");
      var expectedOutput = new BufferedReader(new FileReader(outFilePath))
          .lines().collect(Collectors.joining("\n"));

      if (!output.equals(expectedOutput)) {
        return String.format("Test case %d of %d failed\nOutput: %s\nExpected: %s", i, n, output, expectedOutput);
      }
      ++i;
    }
    return "All test cases passed! Well done!";
  }

  @Override
  public String runCode(String input, String code, String language) throws IOException, InterruptedException {
    if (!compilers.getCompilers().containsKey(language)) {
      throw new CompilerNotFoundException(language);
    }

    final Compilers.SingleCompiler singleCompiler = compilers.getCompilers().get(language);
    final String compiler = singleCompiler.getCompiler();
    final String ext = singleCompiler.getExt();

    String codeFilePath = UUID.randomUUID() + ext;
    PrintWriter pw = new PrintWriter(codeFilePath);
    pw.println(code);
    pw.close();

    String execCommand = String.format("cmd.exe /c echo %s | %s %s", input, compiler, codeFilePath);
    Process process = Runtime.getRuntime().exec(execCommand);
    InputStream stream = process.getInputStream();

    process.waitFor();
    process.destroy();

    new File(codeFilePath).delete();

    return new BufferedReader(new InputStreamReader(stream))
        .lines().collect(Collectors.joining());
  }

  @Override
  public String runCodeWithTestCases(Long problemId, String language, String code)
      throws IOException, InterruptedException {
    var mergedCode = this.createCode(problemId, language, code);
    var testCases =
        new File("res/problems-starter-code/")
            .listFiles((dir, name) -> name.startsWith(problemId.toString()) && name.contains("IN"));

    return runTestCases(testCases, mergedCode, language);
  }

  @Override
  public String createCode(Long problemId, String language, String code)
      throws FileNotFoundException {
    if (!compilers.getCompilers().containsKey(language)) {
      throw new CompilerNotFoundException(language);
    }

    final Compilers.SingleCompiler compiler = compilers.getCompilers().get(language);
    final String ext = compiler.getExt();

    String runnerCodeFileName = String.format("res\\problems-starter-code\\%d-runner%s", problemId, ext);
    String runnerCode = new BufferedReader(new FileReader(runnerCodeFileName))
        .lines().collect(Collectors.joining("\n"));

    return runnerCode + "\n" + code;
  }
}
