package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.rest.api.CodeRunnerApi;
import mk.com.codehelp.core.rest.model.RunCodeRequest;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class CodeRunnerController implements CodeRunnerApi {
  private final CodeRunnerService codeRunnerService;

  @Override
  @SneakyThrows
  public ResponseEntity<String> runCode(RunCodeRequest body) {

    String mergedCode = codeRunnerService.createCode(
        body.getProblemId(),
        body.getLanguage(),
        body.getCode()
    );
    String output = codeRunnerService.runCode(body.getInput(), mergedCode, body.getLanguage());

    return ResponseEntity.ok(output);
  }
}
