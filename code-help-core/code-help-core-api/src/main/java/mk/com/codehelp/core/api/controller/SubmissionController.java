package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.SubmissionMapper;
import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.api.SubmissionApi;
import mk.com.codehelp.core.rest.model.CreatedSubmissionResponse;
import mk.com.codehelp.core.rest.model.CreatedSubmissionResponseLinks;
import mk.com.codehelp.core.rest.model.Link;
import mk.com.codehelp.core.rest.model.PaginationLinks;
import mk.com.codehelp.core.rest.model.SubmissionBaseEntry;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
import mk.com.codehelp.core.rest.model.SubmissionStatus;
import mk.com.codehelp.core.rest.model.SubmissionsResponse;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.service.SubmissionProblemService;
import mk.com.codehelp.core.service.service.SubmissionService;
import mk.com.codehelp.core.service.util.AuthenticationUtil;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class SubmissionController implements SubmissionApi {

  private final SubmissionService submissionService;
  private final SubmissionProblemService submissionProblemService;
  private final SubmissionMapper submissionMapper;
  private final LinksFactory linksFactory;
  private final AuthenticationUtil authenticationUtil;

  @Override
  @SneakyThrows
  public ResponseEntity<CreatedSubmissionResponse> createSubmissionsEntry(
    Long problemId, String authorization, SubmissionBaseEntry body) {

    CreatedSubmissionDto createdSubmissionDto = submissionService.create(problemId, body.getCode(), body.getLanguage());

    Link getSubmissionsLink = linksFactory.getSelfRelLink(
        methodOn(SubmissionController.class)
          .getSubmissions(authorization, null, null, null, null, null, problemId));

    CreatedSubmissionResponseLinks links = new CreatedSubmissionResponseLinks().getSubmissions(getSubmissionsLink);
    CreatedSubmissionResponse response = submissionMapper.convert(createdSubmissionDto).links(links);

    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<SubmissionsResponse> getSubmissions(
    String authorization,
    Integer page,
    Integer size,
    List<String> sortBy,
    String user,
    SubmissionStatus status,
    Long problemId) {

    Pageable pageable = PageUtil.createPageRequest(page, size, sortBy);

    SubmissionFilter submissionFilter = new SubmissionFilter();
    submissionFilter.setStatus(submissionMapper.convert(status));

    String filterUser = user == null ? authenticationUtil.getUserId() : user;
    submissionFilter.setUserId(filterUser);

    PageInfoDto<SubmissionValue> submissionPage =
      problemId == null
        ? submissionService.findAll(submissionFilter, pageable)
        : submissionProblemService.findAll(submissionFilter, problemId, pageable);

    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
      submissionPage,
      (pageNumber, pageSize) ->
        methodOn(SubmissionController.class)
          .getSubmissions(authorization, pageNumber, pageSize, sortBy, user, status, problemId));

    List<SubmissionEntry> submissionEntries = submissionMapper.convert(submissionPage.getItems());
    SubmissionsResponse response = new SubmissionsResponse()
      .pageNumber(submissionPage.getPageNumber())
      .pageSize(submissionPage.getPageSize())
      .totalElements(submissionPage.getTotalElements())
      .totalPages(submissionPage.getTotalPages())
      .submissions(submissionEntries)
      .links(paginationLinks);

    return ResponseEntity.ok(response);
  }
}
