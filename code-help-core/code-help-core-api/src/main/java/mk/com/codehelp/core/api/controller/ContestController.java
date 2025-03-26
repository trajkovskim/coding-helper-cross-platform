package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.ContestMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.api.ContestsApi;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.rest.model.ContestsResponse;
import mk.com.codehelp.core.rest.model.PaginationLinks;
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
  private final ContestMapper contestConverter;
  private final LinksFactory linksFactory;

  @Override
  public ResponseEntity<ContestProblem> getContestProblem(Long contestId, Long problemId, String language) {
    ContestProblemDto contestProblemDto = contestService.getContestProblem(contestId, problemId, language);
    ContestProblem entry = contestConverter.convertContestProblem(contestProblemDto);
    return ResponseEntity.ok(entry);
  }

  @Override
  public ResponseEntity<ContestsResponse> getContestEntries(Integer page, Integer size, List<String> sortBy) {

    Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);
    PageInfoDto<Contest> contestPage = contestService.findAll(pageRequest);

    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
        contestPage,
        (pageNumber, pageSize) ->
            methodOn(ContestController.class).getContestEntries(pageNumber, pageSize, sortBy));

    List<ContestEntry> contests = contestConverter.convertListOfContestModel(contestPage.getItems());
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
  public ResponseEntity<ContestEntry> getContestEntry(Long id) {
    Contest contest = contestService.findById(id);
    ContestEntry entry = contestConverter.convertContest(contest);
    return ResponseEntity.ok(entry);
  }
}
