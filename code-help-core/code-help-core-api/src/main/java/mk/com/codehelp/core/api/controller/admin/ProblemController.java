package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.admin.rest.model.ProblemRequest;
import mk.com.codehelp.core.api.controller.CodingHelperController;
import mk.com.codehelp.core.api.mappers.admin.ProblemMapper;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.admin.api.AdminApi;
import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.Difficulty;
import mk.com.codehelp.core.rest.admin.model.ProblemDetail;
import mk.com.codehelp.core.rest.admin.model.ProblemResponse;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@CodingHelperController
@RequiredArgsConstructor
public class ProblemController implements AdminApi {

  private final ProblemService problemService;

  private final ContestService contestService;
  private final ProblemMapper problemMapper;

  private ProblemRequest createProblemRequest(
      Category category,
      String title,
      Difficulty difficulty,
      String markdown,
      MultipartFile starterCode,
      MultipartFile runnerCode,
      List<MultipartFile> testCases
  ) {
    return ProblemRequest.builder()
        .category(category)
        .title(title)
        .difficulty(difficulty)
        .markdown(markdown)
        .starterCode(starterCode.getResource())
        .runnerCode(runnerCode.getResource())
        .testCases(testCases.stream().map(MultipartFile::getResource).toList())
        .build();
  }

  @Override
  @SneakyThrows
  public ResponseEntity<String> createProblem(String title, Difficulty difficulty, String markdown, MultipartFile starterCode, MultipartFile runnerCode, List<MultipartFile> testCases, String authorization, Long contestId, Category category) {
    ProblemRequest problemRequest = createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);

    Problem problem = problemMapper.convert(problemRequest);

    if(contestId == null) {
      problemService.create(problem);
    } else {
      contestService.addProblemToContest(contestId, problem);
    }

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<ProblemResponse> getAllProblems(String authorization) {

    List<Problem> problems = problemService.findAll();

    return ResponseEntity.ok(problemMapper.convert(problems));
  }

  @Override
  public ResponseEntity<ProblemDetail> getProblem(Long id, String authorization) {

    ProblemDetail problemDetail = problemMapper.convert(problemService.findById(id));

    return ResponseEntity.ok(problemDetail);
  }

  @SneakyThrows
  @Override
  public ResponseEntity<ProblemDetail> updateProblem(Long id, String title, Difficulty difficulty, String markdown, MultipartFile starterCode, MultipartFile runnerCode, List<MultipartFile> testCases, String authorization, Category category) {
    ProblemRequest problemRequest = createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);

    Problem problem = problemMapper.convert(id, problemRequest);

    Problem updated = problemService.update(id, problem);

    ProblemDetail problemDetail = problemMapper.convert(updated);

    return ResponseEntity.ok(problemDetail);
  }

  @Override
  public ResponseEntity<Void> deleteProblem(Long id, String authorization) {

    problemService.deleteById(id);

    return ResponseEntity.noContent().build();
  }
}
