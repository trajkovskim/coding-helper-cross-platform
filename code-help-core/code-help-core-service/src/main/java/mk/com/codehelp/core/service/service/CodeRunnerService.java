package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.File;

import java.io.IOException;
import java.util.List;

public interface CodeRunnerService {
  String runTestCases(List<File> testCases, String codeFilePath, String language) throws IOException, InterruptedException;

  String runCode(String input, String codeFilePath, String language) throws IOException, InterruptedException;

  String runCodeWithTestCases(Long problemId, String language, String code) throws IOException, InterruptedException;

  String createCode(Long problemId, String language, String code);

  String createCode(String language, String code, String runnerCode);
}
