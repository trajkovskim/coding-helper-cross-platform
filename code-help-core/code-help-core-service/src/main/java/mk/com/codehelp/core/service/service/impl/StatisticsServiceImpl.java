package mk.com.codehelp.core.service.service.impl;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.value.SubmissionByCategoryCountPairsValue;
import mk.com.codehelp.core.domain.model.value.SubmissionByLanguageCountPairsValue;
import mk.com.codehelp.core.domain.model.value.UserRankingValue;
import mk.com.codehelp.core.domain.repository.StatisticsRepository;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.UserRankingDto;
import mk.com.codehelp.core.service.dto.UserStatisticsDto;
import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.repository.SubmissionRepository;
import mk.com.codehelp.core.service.service.StatisticsService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {

  private final SubmissionRepository submissionRepository;
  private final StatisticsRepository statisticsRepository;

  @Override
  public UserStatisticsDto getStatistics(String username) {

    final Long easySolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser_Username(
        SubmissionStatus.ACCEPTED, Difficulty.EASY, username);
    final Long mediumSolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser_Username(
        SubmissionStatus.ACCEPTED, Difficulty.MEDIUM, username);
    final Long hardSolved = submissionRepository.countDistinctByStatusAndProblem_DifficultyAndUser_Username(
        SubmissionStatus.ACCEPTED, Difficulty.HARD, username);

    List<SubmissionByLanguageCountPairsValue> solvedByLanguageCount = statisticsRepository.getCountsByLanguagePairs(
      username, SubmissionStatus.ACCEPTED);

    List<SubmissionByCategoryCountPairsValue> solvedByCategoryCount = statisticsRepository.getCountsByCategoryPairs(
      username, SubmissionStatus.ACCEPTED);

    return UserStatisticsDto.builder()
      .solved(easySolved + mediumSolved + hardSolved)
      .easy(easySolved)
      .medium(mediumSolved)
      .hard(hardSolved)
      .languageCounts(solvedByLanguageCount)
      .categoryCounts(solvedByCategoryCount)
      .build();
  }

  @Override
  public PageInfoDto<UserRankingDto> getRankings(String user, Integer page, Integer size) {

    Pageable pageable = PageRequest.of(page, size);
    Page<UserRankingValue> userRankingsPage = statisticsRepository.getUserRankings(pageable);

    AtomicLong atomicLong = new AtomicLong(page.longValue() * size.longValue());
    return PageUtil.createPageInfo(userRankingsPage, pageable, userRanking -> UserRankingDto.builder()
      .user(userRanking.getUser())
      .score(userRanking.getScore())
      .ranking(atomicLong.getAndIncrement())
      .build());
  }
}
