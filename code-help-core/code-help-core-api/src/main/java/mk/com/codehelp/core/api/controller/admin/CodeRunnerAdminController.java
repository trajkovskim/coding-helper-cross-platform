package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.admin.rest.model.CodeRunnerRequest;
import mk.com.codehelp.core.api.mappers.FileMapper;
import mk.com.codehelp.core.domain.model.File;
import mk.com.codehelp.core.rest.admin.api.CodeRunnerApi;
import mk.com.codehelp.core.rest.admin.model.CodeRunnerResponse;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class CodeRunnerAdminController implements CodeRunnerApi {

  private final CodeRunnerService codeRunnerService;

  private final FileMapper fileMapper;

  private CodeRunnerRequest createCodeRunnerRequest(
      String runnerCode, String language, String code, List<MultipartFile> testCases) {
    return CodeRunnerRequest.builder()
        .language(language)
        .code(code)
        .runnerCode(runnerCode)
        .testCases(testCases.stream().map(MultipartFile::getResource).toList())
        .build();
  }

  @Override
  @SneakyThrows
  public ResponseEntity<CodeRunnerResponse> runCode(
      String runnerCode, String language, String code, List<MultipartFile> testCases) {

    CodeRunnerRequest codeRunnerRequest = createCodeRunnerRequest(runnerCode, language, code, testCases);

    String mergedCode = codeRunnerService.createCode(language, code, runnerCode);

    List<File> testCaseFiles =
        codeRunnerRequest.getTestCases()
            .stream()
            .map(this::convertResourceToFile)
            .toList();

    String runTestCasesMessage = codeRunnerService.runTestCases(testCaseFiles, mergedCode, language);

    CodeRunnerResponse codeRunnerResponse = new CodeRunnerResponse().message(runTestCasesMessage);

    return ResponseEntity.ok(codeRunnerResponse);
  }

  @SneakyThrows
  private File convertResourceToFile(Resource resource) {
      return fileMapper.convertResourceToFile(resource);
  }
}
