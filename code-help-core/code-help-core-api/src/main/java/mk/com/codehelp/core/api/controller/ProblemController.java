package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.api.ProblemsApi;
import mk.com.codehelp.core.rest.model.*;
import mk.com.codehelp.core.service.service.ProblemService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import java.util.List;

@CodingHelperController
@RequiredArgsConstructor
public class ProblemController implements ProblemsApi {
  private final ProblemService problemService;
  private final ProblemMapper problemConverter;

  @Override
  public ResponseEntity<ProblemsResponse> getProblemEntries() {
    List<Problem> problems = problemService.findAll();
    ProblemsResponse response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ProblemsTop10Response> getTop10Problems() {
    List<ProblemByLikesDto> problems = problemService.findTop10ByOrderByLikes();
    ProblemsTop10Response response = problemConverter.convertListOfProblemByLikesToResponse(problems);
    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ProblemByLikes> getProblemEntry(Long id) {
    Problem problem = problemService.findById(id);
    ProblemByLikes entry = problemConverter.convertProblemByLikes(problem);
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
    List<Problem> problems = problemService.findAllLikedBy(user);
    final var response = problemConverter.convertListOfProblemToResponse(problems);
    return ResponseEntity.ok(response);
  }
}
