package mk.com.codehelp.core.service.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public interface CodeRunnerService {
  String runTestCases(File[] testCases, String codeFilePath, String language) throws IOException, InterruptedException;

  String runCode(String input, String codeFilePath, String language) throws IOException, InterruptedException;

  String runCodeWithTestCases(Long problemId, String fileName, String language, String code) throws IOException, InterruptedException;

  String createCode(Long problemId, String fileName, String language, String code) throws FileNotFoundException;
}
