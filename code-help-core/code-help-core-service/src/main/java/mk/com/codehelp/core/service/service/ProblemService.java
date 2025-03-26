package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;

import java.io.IOException;

import org.springframework.data.domain.Pageable;

public interface ProblemService {

  PageInfoDto<ProblemValue> findAll(ProblemFilter filter, Pageable pageable);

  Problem create(Problem problem) throws IOException;

  Problem findById(Long id);

  ProblemDto getProblem(Long id, String language);

  Problem deleteById(Long id);

  Problem update(Long id, Problem problem);

  boolean likeToggle(Long id, String email);

  boolean isLikedBy(Long problemId, String email);
}
