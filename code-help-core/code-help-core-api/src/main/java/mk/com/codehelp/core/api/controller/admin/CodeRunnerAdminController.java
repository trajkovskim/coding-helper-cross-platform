package mk.com.codehelp.core.api.controller.admin;

import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.admin.api.CodeRunnerApi;
import mk.com.codehelp.core.rest.admin.model.CodeRunnerRequest;
import mk.com.codehelp.core.rest.admin.model.CodeRunnerResponse;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class CodeRunnerAdminController implements CodeRunnerApi {

  private final CodeRunnerService codeRunnerService;
  private final ProblemMapper problemMapper;

  @Override
  @SneakyThrows
  public ResponseEntity<CodeRunnerResponse> runCode(CodeRunnerRequest codeRunnerRequest) {

    List<Problem.TestCase> testCases = codeRunnerRequest.getTestCases()
        .stream()
        .map(problemMapper::convert)
        .toList();

    CodeRunnerDto runTestCasesMessage = codeRunnerService.runTestCases(
        testCases, codeRunnerRequest.getCode(), codeRunnerRequest.getLanguage());

    CodeRunnerResponse codeRunnerResponse = new CodeRunnerResponse().message(runTestCasesMessage.getMessage());

    return ResponseEntity.ok(codeRunnerResponse);
  }
}
