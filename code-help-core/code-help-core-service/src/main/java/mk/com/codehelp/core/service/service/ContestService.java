package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.ContestProblem;
import mk.com.codehelp.core.domain.model.Problem;

import java.io.IOException;
import java.util.List;

public interface ContestService {
  List<Contest> findAll();

  Contest findById(Long id);

  Contest createContest(Contest contest);

  Contest edit(Long id, Contest contest);

  ContestProblem addProblemToContest(Long id, Problem problem) throws IOException;

  boolean removeProblemFromContest(Long contestId, Long problemId);

  ContestProblem setProblemScore(Long contestId, Long problemId, Long score);

  ContestProblem getContestProblem(Long contestId, Long problemId);

  boolean startContest(Long contestId);

  boolean closeContest(Long id);

  void deleteById(Long id);
}
