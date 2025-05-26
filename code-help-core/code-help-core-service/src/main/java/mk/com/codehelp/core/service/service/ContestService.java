package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.value.ContestValue;
import mk.com.codehelp.core.service.dto.ContestDto;
import mk.com.codehelp.core.service.dto.ContestProblemDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;

import java.io.IOException;

import org.springframework.data.domain.Pageable;

public interface ContestService {

  PageInfoDto<ContestValue> findAll(ContestFilter contestFilter, Pageable pageable);

  Contest findById(Long id);

  ContestDto getContest(Long id, String language);

  Contest createContest(Contest contest);

  Contest update(Long id, Contest contest);

  ContestProblem addProblemToContest(Long id, Integer score, Problem problem) throws IOException;

  ContestProblemDto getContestProblem(Long contestId, Long problemId, String language);

  boolean startContest(Long contestId);

  boolean closeContest(Long id);

  void deleteById(Long id);
}
