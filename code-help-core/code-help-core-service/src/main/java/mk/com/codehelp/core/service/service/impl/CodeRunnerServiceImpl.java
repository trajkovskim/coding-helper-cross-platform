package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.stereotype.Service;

import java.io.*;

@Service
@RequiredArgsConstructor
public class CodeRunnerServiceImpl implements CodeRunnerService {
  @Override
  public String runTestCases(File[] testCases, String codeFilePath, String language) throws IOException {
    int n = testCases.length;
    int i = 1;
    for (File testCase : testCases) {
      // Read IN file
      String inFilePath = testCase.getPath();
      var input = new BufferedReader(new FileReader(inFilePath))
          .lines()
          .reduce(String::concat)
          .orElse("");

      var output = this.runCode(input, codeFilePath, language);

      // Read OUT file
      String outFilePath = testCase.getPath().replace("IN", "OUT");
      var expectedOutput = new BufferedReader(new FileReader(outFilePath))
          .lines()
          .reduce(String::concat)
          .orElse("");

      if (!output.equals(expectedOutput)) {
        return String.format("Test case %d of %d failed\nOutput: %s\nExpected: %s", i, n, output, expectedOutput);
      }
      ++i;
    }
    return "All test cases passed! Well done!";
  }

  @Override
  public String runCode(String input, String codeFilePath, String language) throws IOException {
    String compilerPath = null;
    if (language.equalsIgnoreCase("javascript")) {
      compilerPath = "res\\compilers\\node.exe";
    }

    String execCommand = String.format("cmd.exe /c echo %s | %s %s", input, compilerPath, codeFilePath);
    Process process = new ProcessBuilder(execCommand).start();
    InputStream inputStream = process.getInputStream();

    return new BufferedReader(new InputStreamReader(inputStream))
        .lines()
        .reduce(String::concat)
        .orElse("");
  }

  @Override
  public String runCodeWithTestCases(Long problemId, String fileName, String language, String code)
      throws IOException {
    var codeFilePath = this.createCodeFile(problemId, fileName, language, code);
    var testCases =
        new File("res/problems-starter-code/")
            .listFiles((dir, name) -> name.startsWith(problemId.toString()) && name.contains("IN"));
    return runTestCases(testCases, codeFilePath, language);
  }

  @Override
  public String createCodeFile(Long problemId, String fileName, String language, String code)
      throws FileNotFoundException {
    String ext = null;
    if (language.equalsIgnoreCase("javascript")) {
      ext = ".js";
    }

    String codeFilePath = String.format("res\\users-code\\%s%s", fileName, ext);
    PrintWriter pw_userCode = new PrintWriter(codeFilePath); // Creates or recreates file

    String runnerCodeFileName = String.format("res\\problems-starter-code\\%d-runner%s", problemId, ext);
    new BufferedReader(new FileReader(runnerCodeFileName))
        .lines()
        .forEach(pw_userCode::print);

    pw_userCode.println();
    pw_userCode.print(code);
    pw_userCode.close();

    return codeFilePath;
  }
}
