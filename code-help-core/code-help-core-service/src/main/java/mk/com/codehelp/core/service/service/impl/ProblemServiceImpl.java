package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.domain.repository.ProblemRepository;
import mk.com.codehelp.core.domain.repository.UserRepository;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.dto.ProblemEmbeddedDto;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import mk.com.codehelp.core.service.exceptions.CodeDoesNotExistException;
import mk.com.codehelp.core.service.service.CategoryService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.service.SubmissionProblemService;
import mk.com.codehelp.core.service.service.UserService;
import mk.com.codehelp.core.service.util.AuthenticationUtil;
import mk.com.codehelp.core.service.util.PageUtil;
import mk.com.codehelp.core.service.util.ProblemUtil;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProblemServiceImpl implements ProblemService {

  private final ProblemRepository problemRepository;
  private final CategoryService categoryService;

  private final ProblemUtil problemUtil;
  private final SubmissionProblemService submissionProblemService;
  private final AuthenticationUtil authenticationUtil;
  private final UserService userService;

  @Override
  public PageInfoDto<ProblemDto> findAll(ProblemFilter filter, String user, Pageable pageable) {

    Page<ProblemValue> problemValuePage = this.problemRepository.findAll(filter, pageable);

    return PageUtil.createPageInfo(problemValuePage, pageable, problem -> {

      ProblemDto.ProblemDtoBuilder<?, ?> builder = ProblemDto.builder()
        .id(problem.getId())
        .name(problem.getName())
        .description(problem.getDescription())
        .category(problem.getCategory())
        .difficulty(problem.getDifficulty())
        .markdown(problem.getMarkdown())
        .likes(problem.getLikes())
        .testCases(problem.getTestCases());

      return finalize(builder, problem, user);
    });
  }

  @Override
  public PageInfoDto<ProblemDto> findAll(ProblemFilter filter, Pageable pageable) {
    return this.findAll(filter, null, pageable);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public Problem create(Problem problem) throws IOException {

    Category category = problem.getCategory();
    Category savedCategory = categoryService.getOrCreate(category.getName(), category.getDescription());

    problem.setCategory(savedCategory);

    return problemRepository.save(problem);
  }

  @Override
  public Problem findById(Long id) {
    return this.problemRepository.findById(id).orElseThrow(() -> new ProblemNotFoundException(id));
  }

  @Override
  public ProblemDto getProblem(Long id, String user, String language) {

    ProblemValue problemValue = this.problemRepository.findProblemById(id)
        .orElseThrow(() -> new ProblemNotFoundException(id));

    Problem.Code code = problemUtil.getCodeByLanguage(problemValue.getCodes(), language)
        .orElseThrow(() -> new CodeDoesNotExistException(id, language));

    ProblemDto.ProblemDtoBuilder<?, ?> builder = ProblemDto.builder()
      .id(id)
      .name(problemValue.getName())
      .description(problemValue.getDescription())
      .difficulty(problemValue.getDifficulty())
      .markdown(problemValue.getMarkdown())
      .category(problemValue.getCategory())
      .code(code)
      .likes(problemValue.getLikes())
      .testCases(problemValue.getTestCases());

    return finalize(builder, problemValue, user);
  }

  private ProblemDto finalize(ProblemDto.ProblemDtoBuilder<?, ?> builder, ProblemValue problemValue, String user) {

    if (user != null) {
      SubmissionFilter submissionFilter = new SubmissionFilter();
      submissionFilter.setUser(user);
      SubmissionValue latestSubmission =
        submissionProblemService.findLatest(submissionFilter, problemValue.getId()).orElse(null);

      submissionFilter.setStatus(SubmissionStatus.ACCEPTED);
      SubmissionValue latestAcceptedSubmission =
        submissionProblemService.findLatest(submissionFilter, problemValue.getId()).orElse(null);

      return builder
        .lastSubmission(latestSubmission)
        .lastAcceptedSubmission(latestAcceptedSubmission)
        .build();
    }

    return builder.build();
  }

  @Override
  public ProblemDto getProblem(Long id, String language) {
    return getProblem(id, null, language);
  }

  @Override
  public void deleteById(Long id) {

    if (problemRepository.existsById(id)) {
      this.problemRepository.deleteById(id);
    }
  }

  @Override
  public Problem update(Long id, Problem problemInput) {
    Category category = categoryService.findByName(problemInput.getCategory().getName());

    Problem oldProblem = this.findById(id);
    oldProblem.setName(problemInput.getName());
    oldProblem.setDescription(problemInput.getDescription());
    oldProblem.setDifficulty(problemInput.getDifficulty());
    oldProblem.setCategory(category);
    oldProblem.setMarkdown(problemInput.getMarkdown());
    oldProblem.setDescription(problemInput.getDescription());
    oldProblem.setCodes(problemInput.getCodes());
    oldProblem.setTestCases(oldProblem.getTestCases());

    return problemRepository.save(oldProblem);
  }

  @Override
  public boolean likeToggle(Long id) {

    Problem problem = findById(id);

    String userId = authenticationUtil.getUserId();
    User currentUser = userService.getByUserId(userId);

    boolean liked = problem.getLikedBy().stream()
      .anyMatch(user -> currentUser.getUserId().equals(user.getUserId()));

    if (liked) {
      problem.getLikedBy().removeIf(user -> currentUser.getUserId().equals(user.getUserId()));
    } else {
      problem.getLikedBy().add(currentUser);
    }

    problemRepository.save(problem);
    return liked;
  }

  @Override
  public boolean isLikedBy(Long problemId, String email) {

    return problemRepository.existsByIdAndLikedBy_UsernameContains(problemId, email);
  }
}
