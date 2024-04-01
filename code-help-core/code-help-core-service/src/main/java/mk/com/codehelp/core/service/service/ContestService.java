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

  Contest update(Long id, Contest contest);

  ContestProblem addProblemToContest(Long id, Problem problem) throws IOException;

  ContestProblem getContestProblem(Long contestId, Long problemId);

  boolean startContest(Long contestId);

  boolean closeContest(Long id);

  void deleteById(Long id);
}
