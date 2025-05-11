package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.ContestMapper;
import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.value.ContestValue;
import mk.com.codehelp.core.rest.api.ContestsApi;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.rest.model.ContestStatus;
import mk.com.codehelp.core.rest.model.ContestsResponse;
import mk.com.codehelp.core.rest.model.PaginationLinks;
import mk.com.codehelp.core.service.dto.ContestDto;
import mk.com.codehelp.core.service.dto.ContestProblemDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.data.domain.Pageable;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class ContestController implements ContestsApi {

  private final ContestService contestService;
  private final ContestMapper contestMapper;
  private final LinksFactory linksFactory;

  @Override
  public ResponseEntity<ContestProblem> getContestProblem(Long contestId, Long problemId, String language) {
    ContestProblemDto contestProblemDto = contestService.getContestProblem(contestId, problemId, language);
    ContestProblem entry = contestMapper.convert(contestProblemDto);
    return ResponseEntity.ok(entry);
  }

  @Override
  public ResponseEntity<ContestsResponse> getContestEntries(Integer page, Integer size, List<String> sortBy, String name, ContestStatus status) {

    Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);

    ContestFilter contestFilter = new ContestFilter();
    contestFilter.setName(name);
    contestFilter.setStatus(contestMapper.convert(status));

    PageInfoDto<ContestValue> contestPage = contestService.findAll(contestFilter, pageRequest);

    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
        contestPage,
        (pageNumber, pageSize) ->
            methodOn(ContestController.class).getContestEntries(pageNumber, pageSize, sortBy, name, status));

    List<ContestEntry> contests = contestMapper.convert(contestPage.getItems());
    ContestsResponse contestsResponse = new ContestsResponse()
        .contests(contests)
        .pageNumber(page)
        .pageSize(size)
        .totalElements(contestPage.getTotalElements())
        .totalPages(contestPage.getTotalPages())
        .links(paginationLinks);

    return ResponseEntity.ok(contestsResponse);
  }

  @Override
  public ResponseEntity<ContestEntry> getContestEntry(Long id, String language) {

    ContestDto contest = contestService.getContest(id, language);
    ContestEntry entry = contestMapper.convert(contest);
    return ResponseEntity.ok(entry);
  }
}
