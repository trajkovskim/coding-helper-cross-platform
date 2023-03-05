package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.dto.UserStatisticsDto;

public interface UserService {
  UserStatisticsDto getStatistics(String user);
}
