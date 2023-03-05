package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.model.ContestBaseEntry;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.rest.model.ContestsResponse;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, DifficultyMapper.class, ProblemMapper.class})
public interface ContestMapper {
  List<ContestEntry> convertListOfContestModel(List<Contest> contests);

  ContestEntry convertContest(Contest contest);

  ContestProblem convertContestProblem(mk.com.codehelp.core.domain.model.ContestProblem contestProblem);

  Contest convertContest(Long id, ContestBaseEntry entry);

  default ContestsResponse toResponse(List<Contest> contests) {
    List<ContestEntry> entries = convertListOfContestModel(contests);
    return new ContestsResponse().contests(entries);
  }
}
