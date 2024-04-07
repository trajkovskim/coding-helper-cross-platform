package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.SubmissionMapper;
import mk.com.codehelp.core.domain.dto.SubmissionDto;
import mk.com.codehelp.core.rest.api.SubmissionApi;
import mk.com.codehelp.core.rest.model.GetSubmissionsRequest;
import mk.com.codehelp.core.rest.model.SubmissionReqBody;
import mk.com.codehelp.core.rest.model.SubmissionsResponse;
import mk.com.codehelp.core.service.service.SubmissionService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class SubmissionController implements SubmissionApi {
  private final SubmissionService submissionService;
  private final SubmissionMapper submissionConverter;

  @Override
  @SneakyThrows
  public ResponseEntity<String> createSubmissionsEntry(String authorization, SubmissionReqBody body) {
    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    String output = submissionService.create(user, body.getProblemId(), body.getCode(), body.getLanguage());
    return ResponseEntity.ok(output);
  }

  @Override
  public ResponseEntity<SubmissionsResponse> getSubmissions(String authorization, GetSubmissionsRequest body) {
    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    List<SubmissionDto> entries;
    if (body.getProblemId() == null) {
      entries = submissionService.findAllSubmissionsByEmail(user);
    } else {
      entries = submissionService.findAllSubmissionsByUserEmailAndProblemId(user, body.getProblemId());
    }
    SubmissionsResponse response = submissionConverter.convertListOfSubmissionToResponse(entries);
    return ResponseEntity.ok(response);
  }
}
