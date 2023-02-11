package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.rest.api.RunCodeApi;
import mk.com.codehelp.core.rest.model.RunCodeRequest;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;

@CodingHelperController
@RequiredArgsConstructor
public class CodeRunnerController implements RunCodeApi {
  private final CodeRunnerService codeRunnerService;

  @Override
  @SneakyThrows
  public ResponseEntity<String> runCode(RunCodeRequest body) {
    String email = SecurityContextHolder.getContext().getAuthentication().getName();

    String mergedCode = codeRunnerService.createCode(
        body.getProblemId(),
        email,
        body.getLanguage(),
        body.getCode()
    );
    String output = codeRunnerService.runCode(body.getInput(), mergedCode, body.getLanguage());

    return ResponseEntity.ok(output);
  }
}
