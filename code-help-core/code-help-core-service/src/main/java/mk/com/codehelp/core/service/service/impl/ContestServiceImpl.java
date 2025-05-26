package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.value.ContestValue;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.value.relations.ContestProblemValue;
import mk.com.codehelp.core.domain.repository.ContestRepository;
import mk.com.codehelp.core.domain.repository.impl.ContestProblemRepository;
import mk.com.codehelp.core.service.dto.ContestDto;
import mk.com.codehelp.core.service.dto.ContestProblemDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.exceptions.ContestNotFoundException;
import mk.com.codehelp.core.service.exceptions.ContestStatusException;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.domain.enums.ContestStatus;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.service.util.PageUtil;
import mk.com.codehelp.core.service.util.ProblemUtil;

import org.springframework.context.annotation.Primary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Primary
@Service
@RequiredArgsConstructor
public class ContestServiceImpl implements ContestService {

  protected final ContestRepository contestRepository;
  protected final ContestProblemRepository contestProblemRepository;
  protected final ProblemService problemService;

  protected final ProblemUtil problemUtil;

  @Override
  public PageInfoDto<ContestValue> findAll(ContestFilter contestFilter, Pageable pageable) {

    Page<ContestValue> pageContest = contestRepository.findAll(contestFilter, pageable);

    return PageUtil.createPageInfo(pageContest, pageable);
  }

  @Override
  public Contest findById(Long id) {

    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));

    if (contest.getStatus() == ContestStatus.OPEN) {
      contest.setProblems(List.of());
    }

    return contest;
  }

  @Override
  public ContestDto getContest(Long id, String language) {

    ContestValue contestValue = contestRepository.findContestById(id)
      .orElseThrow(() -> new ContestNotFoundException(id));

    List<ContestProblemValue> contestProblemValues = contestProblemRepository.getContestProblems(id);
    List<ContestProblemDto> contestProblemDtos = contestProblemValues.stream()
      .<ContestProblemDto>map(contestProblem -> {

        ProblemValue problemValue = contestProblem.getProblem();

        Problem.Code code = problemUtil.getCodeByLanguage(problemValue.getCodes(), language)
          .orElse(null);

        return ContestProblemDto.builder()
          .id(problemValue.getId())
          .name(problemValue.getName())
          .description(problemValue.getDescription())
          .difficulty(problemValue.getDifficulty())
          .likes(problemValue.getLikes())
          .category(problemValue.getCategory())
          .markdown(problemValue.getMarkdown())
          .testCases(problemValue.getTestCases())
          .code(code)
          .score(contestProblem.getScore())
          .build();
      }
    ).toList();

    return ContestDto.builder()
      .id(contestValue.getId())
      .name(contestValue.getName())
      .description(contestValue.getDescription())
      .startDate(contestValue.getStartDate())
      .problems(contestProblemDtos)
      .duration(contestValue.getDuration())
      .status(contestValue.getStatus())
      .build();
  }

  @Override
  public ContestProblem addProblemToContest(Long id, Integer score, Problem problem) throws IOException {

    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));

    if (contest.getStatus() != ContestStatus.OPEN)
      throw new ContestStatusException(id, ContestStatus.OPEN);

    Problem createdProblem = problemService.create(problem);
    ContestProblem contestProblem = new ContestProblem(createdProblem, score);
    contest.getProblems().add(contestProblem);
    contestRepository.save(contest);
    return contestProblem;
  }

  @Override
  public ContestProblemDto getContestProblem(Long contestId, Long problemId, String language) {

    Contest contest = contestRepository.findById(contestId).orElseThrow(() -> new ContestNotFoundException(contestId));

    ContestProblem contestProblem = contest.getProblems().stream()
        .filter(problem -> problem.getProblem().getId().equals(problemId))
        .findFirst().orElseThrow(() -> new ProblemNotFoundException(problemId));

    Problem problem = contestProblem.getProblem();

    Problem.Code code = problemUtil.getCodeByLanguage(problem.getCodes(), language)
        .orElse(null);

    return ContestProblemDto.builder()
        .id(problemId)
        .name(problem.getName())
        .difficulty(problem.getDifficulty())
        .markdown(problem.getMarkdown())
        .category(problem.getCategory())
        .code(code)
        .likes((long) problem.getLikedBy().size())
        .score(contestProblem.getScore())
        .build();
  }

  @Override
  public boolean startContest(Long id) {

    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));

    if (contest.getStatus() != ContestStatus.OPEN) {
      throw new ContestStatusException(id, ContestStatus.OPEN);
    }

    contest.setStatus(ContestStatus.STARTED);
    contestRepository.save(contest);

    return true;
  }

  @Override
  public boolean closeContest(Long id) {

    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));

    if (contest.getStatus() != ContestStatus.STARTED) {
      throw new ContestStatusException(id, ContestStatus.STARTED);
    }

    contest.setStatus(ContestStatus.CLOSED);
    contestRepository.save(contest);
    return true;
  }

  @Override
  public Contest createContest(Contest contest) {
//    contest.setStatus(ContestStatus.OPEN);
    return contestRepository.save(contest);
  }

  @Override
  public Contest update(Long id, Contest contest) {

    Contest old = this.findById(id);

    if (contest.getStatus() != ContestStatus.OPEN && old.getStatus() != ContestStatus.OPEN) {
      return null;
    }

    old.setDuration(contest.getDuration());
    old.setName(contest.getName());
    old.setStartDate(contest.getStartDate());
    old.setStatus(contest.getStatus());

    Map<Long, ContestProblem> problemsById =
        contest.getProblems()
            .stream()
            .collect(Collectors.toMap(ContestProblem::getId, problem -> problem));

    List<ContestProblem> updatedContestProblems = old.getProblems().stream()
        .filter(problem -> problemsById.containsKey(problem.getId()))
        .peek(x -> x.setScore(problemsById.get(x.getId()).getScore()))
        .toList();

    old.getProblems().stream().map(ContestProblem::getId)
        .filter(Predicate.not(problemsById::containsKey))
        .forEach(problemService::deleteById);

    old.setProblems(updatedContestProblems);

    return contestRepository.save(old);
  }

  @Override
  public void deleteById(Long id) {
    contestRepository.deleteById(id);
  }
}
