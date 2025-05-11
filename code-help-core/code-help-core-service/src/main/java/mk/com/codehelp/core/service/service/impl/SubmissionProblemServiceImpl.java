package mk.com.codehelp.core.service.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.domain.repository.SubmissionRepository;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.service.SubmissionProblemService;
import mk.com.codehelp.core.service.util.PageUtil;

@Service
@RequiredArgsConstructor
public class SubmissionProblemServiceImpl implements SubmissionProblemService {

  private final SubmissionRepository submissionRepository;

  @Override
  public PageInfoDto<SubmissionValue> findAll(SubmissionFilter submissionFilter, Long problemId, Pageable pageable) {

    Page<SubmissionValue> submissionValuePage = submissionRepository.findAllByProblem(submissionFilter, problemId, pageable);

    return PageUtil.createPageInfo(submissionValuePage, pageable);
  }

  @Override
  public Optional<SubmissionValue> findLatest(SubmissionFilter submissionFilter, Long problemId) {

    Pageable pageable = PageUtil.createPageRequest(0, 1, List.of("submission.createdDate=desc"));
    return findAll(submissionFilter, problemId, pageable).getItems().stream().findFirst();
  }
}
