package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.rest.model.UserRanking;
import mk.com.codehelp.core.service.dto.UserRankingDto;
import mk.com.codehelp.core.service.dto.UserStatisticsDto;
import mk.com.codehelp.core.rest.model.UserStatistics;

import java.util.Collection;
import java.util.List;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface UserMapper {

  @Mapping(target = "solvedByLanguageCount", source = "languageCounts")
  @Mapping(target = "solvedByCategoryCount", source = "categoryCounts")
  UserStatistics convert(UserStatisticsDto statistics);

  @Mapping(target = "user", source = "user.username")
  UserRanking convert(UserRankingDto userRankingDto);
  List<UserRanking> convert(Collection<UserRankingDto> ranking);
}
