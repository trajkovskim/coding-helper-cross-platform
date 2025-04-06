package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.SubmissionMapper;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.api.SubmissionApi;
import mk.com.codehelp.core.rest.model.*;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;
import mk.com.codehelp.core.service.service.SubmissionService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class SubmissionController implements SubmissionApi {
  private final SubmissionService submissionService;
  private final SubmissionMapper submissionMapper;
  private final LinksFactory linksFactory;

  @Override
  @SneakyThrows
  public ResponseEntity<CreatedSubmissionResponse> createSubmissionsEntry(Long problemId, String authorization, SubmissionBaseEntry body) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    CreatedSubmissionDto createdSubmissionDto = submissionService.create(user, problemId, body.getCode(), body.getLanguage());

    Link getSubmissionsLink = linksFactory.getSelfRelLink(
        methodOn(SubmissionController.class).getSubmissions(problemId, authorization));

    CreatedSubmissionResponseLinks links = new CreatedSubmissionResponseLinks().getSubmissions(getSubmissionsLink);
    CreatedSubmissionResponse response = submissionMapper.convert(createdSubmissionDto).links(links);

    return ResponseEntity.ok(response);
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

    List<SubmissionEntry> submissionEntries = submissionMapper.convert(entries);
    SubmissionsResponse response = new SubmissionsResponse().submissions(submissionEntries);

    return ResponseEntity.ok(response);
  }
}
