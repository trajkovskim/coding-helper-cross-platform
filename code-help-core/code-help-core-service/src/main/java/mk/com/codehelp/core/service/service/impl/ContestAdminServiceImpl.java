package mk.com.codehelp.core.service.service.impl;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.repository.ContestRepository;
import mk.com.codehelp.core.domain.repository.impl.ContestProblemRepository;
import mk.com.codehelp.core.service.exceptions.ContestNotFoundException;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.ProblemUtil;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
@Qualifier("contestAdminService")
public class ContestAdminServiceImpl extends ContestServiceImpl implements ContestService {

  public ContestAdminServiceImpl(
    ContestRepository contestRepository,
    ContestProblemRepository contestProblemRepository,
    ProblemService problemService,
    ProblemUtil problemUtil) {

    super(contestRepository, contestProblemRepository, problemService, problemUtil);
  }

  @Override
  public Contest findById(Long id) {
    return contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));
  }
}
