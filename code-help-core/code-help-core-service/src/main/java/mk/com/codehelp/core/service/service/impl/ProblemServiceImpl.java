package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.domain.repository.CategoryRepository;
import mk.com.codehelp.core.domain.repository.ProblemRepository;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import mk.com.codehelp.core.service.exceptions.StarterCodeDoesNotExistException;
import mk.com.codehelp.core.service.service.CategoryService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.ProblemUtil;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class ProblemServiceImpl implements ProblemService {

  private final ProblemRepository problemRepository;
  private final CategoryService categoryService;

  private final ProblemUtil problemUtil;

  @Override
  public Page<ProblemValue> findAll(Pageable pageable, ProblemFilter filter) {
    return this.problemRepository.findAll(pageable, filter);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public Problem create(Problem problem) throws IOException {

    Category category = categoryService.getOrCreate(problem.getCategory().getName());
    problem.setCategory(category);

    return problemRepository.save(problem);
  }

  @Override
  public Problem findById(Long id) {
    return this.problemRepository.findById(id).orElseThrow(() -> new ProblemNotFoundException(id));
  }

  @Override
  public ProblemDto getProblem(Long id, String language) {

    Problem problem = findById(id);

    Problem.Code starterCode = problemUtil.getCodeByLanguage(problem.getStarterCode(), language)
        .orElseThrow(() -> new StarterCodeDoesNotExistException(id, language));

    Problem.Code runnerCode = problemUtil.getCodeByLanguage(problem.getRunnerCode(), language)
        .orElseThrow(() -> new StarterCodeDoesNotExistException(id, language));

    return ProblemDto.builder()
        .id(id)
        .title(problem.getTitle())
        .difficulty(problem.getDifficulty())
        .markdown(problem.getMarkdown())
        .category(problem.getCategory())
        .starterCode(starterCode)
        .runnerCode(runnerCode)
        .likes((long) problem.getLikedBy().size())
        .build();
  }

  @Override
  public Problem deleteById(Long id) {

    Problem problem = this.findById(id);

    this.problemRepository.deleteById(id);
    return problem;
  }

  @Override
  public Problem update(Long id, Problem problemInput) {
    Category category = categoryService.findByName(problemInput.getCategory().getName());

    Problem oldProblem = this.findById(id);
    oldProblem.setDifficulty(problemInput.getDifficulty());
    oldProblem.setCategory(category);
    oldProblem.setMarkdown(problemInput.getMarkdown());
    oldProblem.setTitle(problemInput.getTitle());
    oldProblem.setStarterCode(problemInput.getStarterCode());
    oldProblem.setRunnerCode(problemInput.getRunnerCode());
    oldProblem.setTestCases(oldProblem.getTestCases());

    return problemRepository.save(oldProblem);
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

    return problemRepository.existsByIdAndLikedByContains(problemId, email);
  }
}
