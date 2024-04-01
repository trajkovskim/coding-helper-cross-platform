package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.ContestMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.api.ContestsApi;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.rest.model.ContestsResponse;
import mk.com.codehelp.core.service.service.ContestService;
import org.springframework.http.ResponseEntity;

import java.util.List;

@CodingHelperController
@RequiredArgsConstructor
public class ContestController implements ContestsApi {
  private final ContestService contestService;
  private final ContestMapper contestConverter;

  @Override
  public ResponseEntity<ContestProblem> getContestProblem(Long contestId, Long problemId) {
    mk.com.codehelp.core.domain.model.ContestProblem contestProblem =
        contestService.getContestProblem(contestId, problemId);
    ContestProblem entry = contestConverter.convertContestProblem(contestProblem);
    return ResponseEntity.ok(entry);
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
