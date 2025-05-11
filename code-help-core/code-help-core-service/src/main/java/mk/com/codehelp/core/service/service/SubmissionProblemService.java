package mk.com.codehelp.core.service.service;

import java.util.Optional;

import org.springframework.data.domain.Pageable;

import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.service.dto.PageInfoDto;

public interface SubmissionProblemService {

  PageInfoDto<SubmissionValue> findAll(SubmissionFilter submissionFilter, Long problemId, Pageable pageable);

  Optional<SubmissionValue> findLatest(SubmissionFilter submissionFilter, Long problemId);
}
