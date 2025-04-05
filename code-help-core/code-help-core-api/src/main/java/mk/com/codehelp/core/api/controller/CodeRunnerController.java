package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import mk.com.codehelp.core.api.mappers.CodeRunnerMapper;
import mk.com.codehelp.core.rest.api.CodeRunnerApi;
import mk.com.codehelp.core.rest.model.CodeRunnerRequest;
import mk.com.codehelp.core.rest.model.CodeRunnerResponse;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.CodeUtil;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class CodeRunnerController implements CodeRunnerApi {

  private final CodeRunnerService codeRunnerService;
  private final CodeUtil codeUtil;
  private final ProblemService problemService;
  private final CodeRunnerMapper codeRunnerMapper;

  @Override
  @SneakyThrows
  public ResponseEntity<CodeRunnerResponse> runCode(Long problemId, String authorization, CodeRunnerRequest body) {

    ProblemDto problem = problemService.getProblem(problemId, body.getLanguage());
    String mergedCode = codeUtil.mergeCode(body.getCode(), problem.getCode().getRunner());

    CodeRunnerDto codeRunnerDto = codeRunnerService.runCode(body.getInput(), mergedCode, body.getLanguage());
    CodeRunnerResponse response = codeRunnerMapper.convert(codeRunnerDto);

    return ResponseEntity.ok(response);
  }
}
