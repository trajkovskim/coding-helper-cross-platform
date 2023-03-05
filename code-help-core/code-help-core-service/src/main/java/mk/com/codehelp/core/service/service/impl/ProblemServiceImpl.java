package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.repository.ProblemRepository;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import mk.com.codehelp.core.service.service.CategoryService;
import mk.com.codehelp.core.service.service.ProblemService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Collection;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProblemServiceImpl implements ProblemService {
  private final ProblemRepository problemRepository;
  private final CategoryService categoryService;

  @Override
  public List<Problem> findAll() {
    return this.problemRepository.findAll();
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public Problem create(Problem problem) throws IOException {
    categoryService.findById(problem.getCategory().getName());
    return problemRepository.save(problem);
  }

  @Override
  public Problem findById(Long id) {
    return this.problemRepository.findById(id).orElseThrow(() -> new ProblemNotFoundException(id));
  }

  @Override
  public Problem deleteById(Long id) {
    Problem problem = this.findById(id);
    this.problemRepository.deleteById(id);
    return problem;
  }

  @Override
  public Problem update(Long id, Problem problemInput) {
    Category category = this.categoryService.findById(problemInput.getCategory().getName());

    Problem problem = this.findById(id);
    problem.setDifficulty(problemInput.getDifficulty());
    problem.setCategory(category);
    problem.setMarkdown(problemInput.getMarkdown());
    problem.setTitle(problemInput.getTitle());
    problem.setStarterCode(problemInput.getStarterCode());
    problem.setRunnerCode(problemInput.getRunnerCode());
    problem.setTestCases(problem.getTestCases());

    return problemRepository.save(problem);
  }

  @Override
  public List<Problem> findAllLByCategories(Collection<String> categories) {
    if (categories.isEmpty()) {
      return this.findAll();
    }
    return this.problemRepository.findAllByCategory_NameIn(categories);
  }

  @Override
  public List<ProblemByLikesDto> findTop10ByOrderByLikes() {
    return this.problemRepository.findTop10ByOrderByLikes();
  }

  @Override
  public boolean likeToggle(Long id, String email) {
    Problem problem = findById(id);
    boolean liked = problem.getLikedBy().stream().anyMatch(user -> user.equals(email));
    if (liked) {
      problem.getLikedBy().removeIf(x -> x.equals(email));
    } else {
      problem.getLikedBy().add(email);
    }
    problemRepository.save(problem);
    return liked;
  }

  @Override
  public boolean isLikedBy(Long problemId, String email) {
    return findById(problemId)
        .getLikedBy()
        .stream()
        .anyMatch(x -> x.equals(email));
  }

  @Override
  public boolean delete(Long id) {
    this.deleteById(id);
    return true;
  }
}
