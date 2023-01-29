package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.queries.ProblemByLikesQuery;
import mk.com.codehelp.core.rest.api.ProblemsApi;
import mk.com.codehelp.core.rest.model.*;
import mk.com.codehelp.core.service.service.ProblemService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

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
    List<ProblemByLikesQuery> problems = problemService.findTop10ByOrderByLikes();
    ProblemsTop10Response response = problemConverter.convertListOfProblemByLikesToResponse(problems);
    return ResponseEntity.ok(response);
  }

  private ProblemRequest createProblemRequest(
      Category category,
      String title,
      Difficulty difficulty,
      String markdown,
      MultipartFile starterCode,
      MultipartFile runnerCode,
      List<MultipartFile> testCases
  ) {
    return new ProblemRequest()
        .category(category)
        .title(title)
        .difficulty(difficulty)
        .markdown(markdown)
        .starterCode(starterCode.getResource())
        .runnerCode(runnerCode.getResource())
        .testCases(testCases.stream().map(MultipartFile::getResource).collect(Collectors.toList()));
  }

  @Override
  @SneakyThrows
  public ResponseEntity<Void> createProblemEntry(
      Category category,
      String title,
      Difficulty difficulty,
      String markdown,
      MultipartFile starterCode,
      MultipartFile runnerCode,
      List<MultipartFile> testCases
  ) {
    ProblemRequest problemRequest =
        createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);
    Problem problem = problemConverter.convertProblem(problemRequest);
    problemService.create(problem, starterCode, runnerCode, testCases);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> editProblemEntry(
      Long id,
      Category category,
      String title,
      Difficulty difficulty,
      String markdown,
      MultipartFile starterCode,
      MultipartFile runnerCode,
      List<MultipartFile> testCases
  ) {
    ProblemRequest problemRequest =
        createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);
    Problem problem = problemConverter.convertProblem(problemRequest);
    problemService.update(id, problem);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<ProblemByLikes> getProblemEntry(Long id) {
    Problem problem = problemService.findById(id);
    ProblemEntry entry = problemConverter.convertProblem(problem);
    ProblemByLikes problemByLikes = new ProblemByLikes()
        .problem(entry)
        .likes((long) (problem.getLikedBy().size()));
    return ResponseEntity.ok(problemByLikes);
  }

  @Override
  public ResponseEntity<Void> toggleLikeProblemEntry(Long id) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String email = authentication.getName();
    problemService.likeToggle(id, email);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> deleteProblemEntry(Long id) {
    problemService.deleteById(id);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Boolean> isProblemEntryLiked(Long id) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String email = authentication.getName();
    Boolean isLiked = problemService.isLikedBy(id, email);
    return ResponseEntity.ok(isLiked);
  }
}
