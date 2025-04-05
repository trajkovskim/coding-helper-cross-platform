package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;

import java.io.IOException;
import java.util.List;

public interface CodeRunnerService {

  CodeRunnerDto runTestCases(List<Problem.TestCase> testCases, String code, String language) throws IOException, InterruptedException;

  CodeRunnerDto runCode(String input, String code, String language) throws IOException, InterruptedException;
}
