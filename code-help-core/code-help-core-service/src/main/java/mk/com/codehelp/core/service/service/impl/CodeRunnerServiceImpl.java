package mk.com.codehelp.core.service.service.impl;

import jakarta.annotation.Nonnull;
import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;
import mk.com.codehelp.core.service.runners.Runner;
import mk.com.codehelp.core.service.runners.RunnersFactory;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CodeRunnerServiceImpl implements CodeRunnerService {

  private final RunnersFactory runnersFactory;

  @Override
  public CodeRunnerDto runTestCases(List<Problem.TestCase> testCases, String code, String language)
      throws IOException {

    int i = 1;

    for (final Problem.TestCase testCase : testCases) {

      final CodeRunnerDto output = this.runCode(testCase.getIn(), code, language);

      final String expectedOutput = testCase.getOut();
      if (!output.getMessage().equals(expectedOutput)) {

        return CodeRunnerDto.builder()
          .message(
              "Test case %d of %d failed\nOutput: %s\nExpected: %s"
                  .formatted(i, testCases.size(), output.getMessage(), expectedOutput))
          .error(output.isError())
          .testCasesPassed(i - 1)
          .build();
      }
      ++i;
    }
    return CodeRunnerDto.builder()
      .message("All test cases passed! Well done!")
      .error(false)
      .testCasesPassed(testCases.size())
      .build();
  }

  @Override
  public CodeRunnerDto runCode(@Nonnull String input, String code, String language)
      throws IOException {

    Runner runner = runnersFactory.getRunner(language);
    Process process = runner.run(code, input);

    String error;
    String output;
    try (BufferedReader errorReader = process.errorReader();
         BufferedReader inputReader = process.inputReader()) {

      error = errorReader.lines().collect(Collectors.joining());
      output = inputReader.lines().collect(Collectors.joining());
    }

    process.destroy();

    return CodeRunnerDto.builder()
        .message(output.isEmpty() ? error : output)
        .error(output.isEmpty() || !error.isEmpty())
        .build();
  }
}
