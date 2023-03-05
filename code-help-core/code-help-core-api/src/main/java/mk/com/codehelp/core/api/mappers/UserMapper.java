package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.UserStatisticsDto;
import mk.com.codehelp.core.rest.model.UserStatistics;
import org.mapstruct.Mapper;

@Mapper
public interface UserMapper {
  UserStatistics convertUserStatistics(UserStatisticsDto statistics);
}
