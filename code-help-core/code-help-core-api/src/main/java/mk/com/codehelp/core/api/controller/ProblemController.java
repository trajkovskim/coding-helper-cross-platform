package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.rest.api.ProblemApi;
import mk.com.codehelp.core.rest.model.*;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProblemController implements ProblemApi {

  private final ProblemService problemService;
  private final ProblemMapper problemConverter;

  @Override
  public ResponseEntity<ProblemsResponse> getProblemEntries(
      Integer page, Integer size, List<String> sortBy, List<String> categories, String likedBy) {

    Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);

    ProblemFilter problemFilter = new ProblemFilter();
    problemFilter.setCategories(categories);
    problemFilter.setLikedBy(likedBy);

    Page<ProblemValue> problemsPage = problemService.findAll(pageRequest, problemFilter);
    List<ProblemValue> problems = problemsPage.getContent();
    ProblemsResponse response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ProblemEntryDetail> getProblemEntry(Long id, String language) {

    ProblemDto problemDto = problemService.getProblem(id, language);

    ProblemEntryDetail entry = problemConverter.convertProblem(problemDto);

    return ResponseEntity.ok(entry);
  }

  @Override
  public ResponseEntity<Void> toggleLikeProblemEntry(Long id) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();

    problemService.likeToggle(id, user);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Boolean> isProblemEntryLiked(Long id) {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();

    Boolean isLiked = problemService.isLikedBy(id, user);

    return ResponseEntity.ok(isLiked);
  }

  @Override
  public ResponseEntity<ProblemsResponse> getLikedProblems() {

    String user = SecurityContextHolder.getContext().getAuthentication().getName();

    ProblemFilter problemFilter = new ProblemFilter();
    problemFilter.setLikedBy(user);

    Page<ProblemValue> problemPage = problemService.findAll(Pageable.unpaged(), problemFilter);
    List<ProblemValue> problems = problemPage.getContent();

    final var response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }
}
