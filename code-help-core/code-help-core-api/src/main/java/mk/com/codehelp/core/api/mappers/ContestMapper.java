package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.service.dto.ContestProblemDto;

import java.util.Collection;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, ProblemMapper.class})
public interface ContestMapper {

  List<ContestEntry> convert(Collection<Contest> contests);

  ContestEntry convert(Contest contest);

  ContestProblem convert(ContestProblemDto contestProblemDto);
}
