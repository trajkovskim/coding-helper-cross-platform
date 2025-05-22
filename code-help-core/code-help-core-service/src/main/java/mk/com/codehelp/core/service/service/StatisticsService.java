package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.UserRankingDto;
import mk.com.codehelp.core.service.dto.UserStatisticsDto;

public interface StatisticsService {

  UserStatisticsDto getStatistics(String user);

  PageInfoDto<UserRankingDto> getRankings(String user, Integer page, Integer size);
}
