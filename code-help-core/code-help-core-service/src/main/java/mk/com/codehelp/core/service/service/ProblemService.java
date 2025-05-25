package mk.com.codehelp.core.service.service;

import java.io.IOException;

import org.springframework.data.domain.Pageable;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;

public interface ProblemService {

  PageInfoDto<ProblemDto> findAll(ProblemFilter filter, String user, Pageable pageable);

  PageInfoDto<ProblemDto> findAll(ProblemFilter filter, Pageable pageable);

  Problem create(Problem problem) throws IOException;

  Problem findById(Long id);

  ProblemDto getProblem(Long id, String user, String language);

  ProblemDto getProblem(Long id, String language);

  void deleteById(Long id);

  Problem update(Long id, Problem problem);

  boolean likeToggle(Long id);

  boolean isLikedBy(Long problemId, String userId);
}
