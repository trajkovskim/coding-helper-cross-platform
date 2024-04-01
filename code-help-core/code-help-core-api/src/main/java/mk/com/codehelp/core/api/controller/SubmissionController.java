package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.SubmissionMapper;
import mk.com.codehelp.core.domain.dto.SubmissionDto;
import mk.com.codehelp.core.rest.api.SubmissionsApi;
import mk.com.codehelp.core.rest.api.SubmitApi;
import mk.com.codehelp.core.rest.model.GetSubmissionsRequest;
import mk.com.codehelp.core.rest.model.SubmissionReqBody;
import mk.com.codehelp.core.rest.model.SubmissionsResponse;
import mk.com.codehelp.core.service.service.SubmissionService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.List;
import java.util.Optional;

@CodingHelperController
@RequiredArgsConstructor
public class SubmissionController implements SubmissionsApi, SubmitApi {
  private final SubmissionService submissionService;
  private final SubmissionMapper submissionConverter;

  @Override
  public Optional<NativeWebRequest> getRequest() {
    return SubmissionsApi.super.getRequest();
  }

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
