package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface SubmissionService {

  PageInfoDto<SubmissionValue> findAll(SubmissionFilter submissionFilter, Pageable pageable);

  CreatedSubmissionDto create(Long problemId, String code, String language) throws IOException, InterruptedException;
}
