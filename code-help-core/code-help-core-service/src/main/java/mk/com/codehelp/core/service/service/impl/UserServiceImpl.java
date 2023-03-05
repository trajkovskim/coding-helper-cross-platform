package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.dto.UserStatisticsDto;
import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.repository.SubmissionRepository;
import mk.com.codehelp.core.service.service.UserService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
  private final SubmissionRepository submissionRepository;

  @Override
  public UserStatisticsDto getStatistics(String user) {
    final UserStatisticsDto statistics = new UserStatisticsDto();

    final Long easySolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser(
        SubmissionStatus.ACCEPTED, Difficulty.EASY, user);
    final Long mediumSolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser(
        SubmissionStatus.ACCEPTED, Difficulty.MEDIUM, user);
    final Long hardSolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser(
        SubmissionStatus.ACCEPTED, Difficulty.HARD, user);

    statistics.setSolved(easySolved + mediumSolved + hardSolved);
    statistics.setEasy(easySolved);
    statistics.setMedium(mediumSolved);
    statistics.setHard(hardSolved);

    return statistics;
  }
}
