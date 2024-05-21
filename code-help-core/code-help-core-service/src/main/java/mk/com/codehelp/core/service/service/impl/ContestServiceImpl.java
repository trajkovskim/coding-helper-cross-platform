package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.service.exceptions.ContestNotFoundException;
import mk.com.codehelp.core.service.exceptions.ContestStatusNotOpenException;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.domain.enums.ContestStatus;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.ContestProblem;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.repository.ContestRepository;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Primary
@Service
@RequiredArgsConstructor
public class ContestServiceImpl implements ContestService {
  protected final ContestRepository contestRepository;
  protected final ProblemService problemService;

  @Override
  public List<Contest> findAll() {
    return contestRepository.findAll();
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
  public ContestProblem addProblemToContest(Long id, Problem problem) throws IOException {
    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));
    if (contest.getStatus() != ContestStatus.OPEN)
      throw new ContestStatusNotOpenException(id);

    Problem createdProblem = problemService.create(problem);
    ContestProblem contestProblem = new ContestProblem(createdProblem, 0L);
    contest.getProblems().add(contestProblem);
    contestRepository.save(contest);
    return contestProblem;
  }

  @Override
  public ContestProblem getContestProblem(Long contestId, Long problemId) {
    Contest contest = contestRepository.findById(contestId).orElseThrow(() -> new ContestNotFoundException(contestId));

    return contest.getProblems().stream()
        .filter(problem -> problem.getProblem().getId().equals(problemId))
        .findFirst().orElseThrow(() -> new ProblemNotFoundException(problemId));
  }

  @Override
  public boolean startContest(Long id) {
    Contest contest = contestRepository.findById(id)
        .orElseThrow(() -> new ContestNotFoundException(id));

    if (contest.getStatus() != ContestStatus.OPEN) {
      return false;
    }
    contest.setStatus(ContestStatus.STARTED);
    contestRepository.save(contest);
    return true;
  }

  @Override
  public boolean closeContest(Long id) {
    Contest contest = contestRepository.findById(id).orElseThrow(() -> new ContestNotFoundException(id));
    if (contest.getStatus() != ContestStatus.STARTED) {
      return false;
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
    old.setStartsOn(contest.getStartsOn());
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
