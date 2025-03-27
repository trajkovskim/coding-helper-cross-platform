package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.rest.api.ProblemApi;
import mk.com.codehelp.core.rest.model.*;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class ProblemController implements ProblemApi {

  private final ProblemService problemService;
  private final ProblemMapper problemConverter;
  private final LinksFactory linksFactory;

  @Override
  public ResponseEntity<ProblemsResponse> getProblemEntries(
      Integer page, Integer size, List<String> sortBy, List<String> categories, String likedBy) {

    Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);

    ProblemFilter problemFilter = new ProblemFilter();
    problemFilter.setCategories(categories);
    problemFilter.setLikedBy(likedBy);

    PageInfoDto<ProblemValue> problemsPage = problemService.findAll(problemFilter, pageRequest);
    List<ProblemEntry> problems = problemConverter.convert(problemsPage.getItems());

    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
        problemsPage,
        (pageNumber, pageSize) ->
            methodOn(ProblemController.class).getProblemEntries(pageNumber, pageSize, sortBy, categories, likedBy));

    ProblemsResponse response = new ProblemsResponse()
        .problems(problems)
        .totalElements(problemsPage.getTotalElements())
        .totalPages(problemsPage.getTotalPages())
        .pageNumber(page)
        .pageSize(size)
        .links(paginationLinks);

    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ProblemEntryDetail> getProblemEntry(Long id, String language) {

    ProblemDto problemDto = problemService.getProblem(id, language);

    ProblemEntryDetail entry = problemConverter.convert(problemDto);

    return ResponseEntity.ok(entry);
  }

  @Override
  public ResponseEntity<Void> toggleLikeProblemEntry(Long id, String authorization) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();

    problemService.likeToggle(id, user);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Boolean> isProblemEntryLiked(Long id, String authorization) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();

    Boolean isLiked = problemService.isLikedBy(id, user);

    return ResponseEntity.ok(isLiked);
  }
}
