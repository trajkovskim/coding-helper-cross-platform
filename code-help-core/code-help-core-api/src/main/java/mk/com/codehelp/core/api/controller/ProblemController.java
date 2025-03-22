package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.ProblemFilter;
import mk.com.codehelp.core.rest.api.ProblemApi;
import mk.com.codehelp.core.rest.model.*;
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
    problemFilter.setUser(likedBy);

    Page<ProblemByLikesDto> problemsPage = problemService.findAll(pageRequest, problemFilter);
    List<ProblemByLikesDto> problems = problemsPage.getContent();
    ProblemsResponse response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ProblemEntry> getProblemEntry(Long id) {
    Problem problem = problemService.findById(id);
    ProblemEntry entry = problemConverter.convertProblem(problem);
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
    problemFilter.setUser(user);

    Page<ProblemByLikesDto> problemPage = problemService.findAll(Pageable.unpaged(), problemFilter);
    List<ProblemByLikesDto> problems = problemPage.getContent();

    final var response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }
}
