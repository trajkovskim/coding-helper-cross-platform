package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.SubmissionMapper;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.api.SubmissionApi;
import mk.com.codehelp.core.rest.model.SubmissionBaseEntry;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
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
  public ResponseEntity<String> createSubmissionsEntry(Long problemId, String authorization, SubmissionBaseEntry body) {
    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    String output = submissionService.create(user, problemId, body.getCode(), body.getLanguage());
    return ResponseEntity.ok(output);
  }

  @Override
  public ResponseEntity<SubmissionsResponse> getSubmissions(Long problemId, String authorization) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    List<SubmissionValue> entries;

    if (problemId == null) {
      entries = submissionService.findAllSubmissionsByEmail(user);
    } else {
      entries = submissionService.findAllSubmissionsByUserEmailAndProblemId(user, problemId);
    }

    List<SubmissionEntry> submissionEntries = submissionConverter.convert(entries);
    SubmissionsResponse response = new SubmissionsResponse().submissions(submissionEntries);

    return ResponseEntity.ok(response);
  }
}
