package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.ContestProblem;
import mk.com.codehelp.core.domain.model.Problem;

import java.io.IOException;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ContestService {
  Page<Contest> findAll(Pageable pageable);

  Contest findById(Long id);

  Contest createContest(Contest contest);

  Contest update(Long id, Contest contest);

  ContestProblem addProblemToContest(Long id, Problem problem) throws IOException;

  ContestProblem getContestProblem(Long contestId, Long problemId);

  boolean startContest(Long contestId);

  boolean closeContest(Long id);

  void deleteById(Long id);
}
