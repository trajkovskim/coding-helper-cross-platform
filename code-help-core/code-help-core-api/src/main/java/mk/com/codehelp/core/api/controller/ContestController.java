package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.mappers.ContestMapper;
import mk.com.codehelp.core.api.mappers.ProblemMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.api.ContestApi;
import mk.com.codehelp.core.rest.api.ContestsApi;
import mk.com.codehelp.core.rest.model.Category;
import mk.com.codehelp.core.rest.model.ContestBaseEntry;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.rest.model.ContestsResponse;
import mk.com.codehelp.core.rest.model.Difficulty;
import mk.com.codehelp.core.rest.model.ProblemRequest;
import mk.com.codehelp.core.rest.model.SetContestProblemScoreRequest;
import mk.com.codehelp.core.service.service.ContestService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CodingHelperController
@RequiredArgsConstructor
public class ContestController implements ContestsApi, ContestApi {
  private final ContestService contestService;
  private final ContestMapper contestConverter;
  private final ProblemMapper problemConverter;


  @Override
  public ResponseEntity<Void> closeContest(Long id) {
    contestService.closeContest(id);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> deleteContestProblem(Long contestId, Long problemId) {
    contestService.removeProblemFromContest(contestId, problemId);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<ContestProblem> getContestProblem(Long contestId, Long problemId) {
    mk.com.codehelp.core.domain.model.ContestProblem contestProblem =
        contestService.getContestProblem(contestId, problemId);
    ContestProblem entry = contestConverter.convertContestProblem(contestProblem);
    return ResponseEntity.ok(entry);
  }

  @Override
  public ResponseEntity<Void> setContestProblemScore(Long contestId, Long problemId, SetContestProblemScoreRequest setContestProblemScoreRequest) {
    Long score = setContestProblemScoreRequest.getScore();
    contestService.setProblemScore(contestId, problemId, score);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> startContest(Long id) {
    contestService.startContest(id);
    return ResponseEntity.noContent().build();
  }

  @Override
  public Optional<NativeWebRequest> getRequest() {
    return ContestsApi.super.getRequest();
  }

  @Override
  public ResponseEntity<Void> createContestEntry(ContestBaseEntry contestBaseEntry) {
    Contest contest = contestConverter.convertContest(null, contestBaseEntry);
    contestService.createContest(contest);
    return ResponseEntity.noContent().build();
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
  public ResponseEntity<Void> createContestProblemEntry(
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
    contestService.addProblemToContest(id, problem);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> deleteContestEntry(Long id) {
    contestService.deleteById(id);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> editContestEntry(Long id, ContestBaseEntry contestBaseEntry) {
    Contest contest = contestConverter.convertContest(id, contestBaseEntry);
    contestService.edit(id, contest);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<ContestsResponse> getContestEntries() {
    List<Contest> contests = contestService.findAll();
    ContestsResponse response = contestConverter.toResponse(contests);
    return ResponseEntity.ok(response);
  }

  @Override
  public ResponseEntity<ContestEntry> getContestEntry(Long id) {
    Contest contest = contestService.findById(id);
    ContestEntry entry = contestConverter.convertContest(contest);
    return ResponseEntity.ok(entry);
  }
}
