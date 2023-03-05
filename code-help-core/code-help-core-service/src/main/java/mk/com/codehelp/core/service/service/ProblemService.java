package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.queries.ProblemByLikesQuery;

import java.io.IOException;
import java.util.Collection;
import java.util.List;

public interface ProblemService {
  List<Problem> findAll();

  Problem create(Problem problem) throws IOException;

  Problem findById(Long id);

  Problem deleteById(Long id);

  Problem update(Long id, Problem problem);

  List<Problem> findAllLByCategories(Collection<String> categories);

  List<ProblemByLikesQuery> findTop10ByOrderByLikes();

  boolean likeToggle(Long id, String email);

  boolean isLikedBy(Long problemId, String email);

  boolean delete(Long id);
}
