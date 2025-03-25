package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.service.dto.UserStatisticsDto;

public interface UserService {

  UserStatisticsDto getStatistics(String user);
}
