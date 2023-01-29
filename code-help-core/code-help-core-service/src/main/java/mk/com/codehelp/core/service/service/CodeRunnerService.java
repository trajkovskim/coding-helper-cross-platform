package mk.com.codehelp.core.service.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public interface CodeRunnerService {
  String runTestCases(File[] testCases, String codeFilePath, String language) throws IOException;

  String runCode(String input, String codeFilePath, String language) throws IOException;

  String runCodeWithTestCases(Long problemId, String fileName, String language, String code) throws IOException;

  String createCodeFile(Long problemId, String fileName, String language, String code) throws FileNotFoundException;
}
