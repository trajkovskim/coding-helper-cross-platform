package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.enums.ContestStatus;
import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.value.ContestValue;
import mk.com.codehelp.core.rest.model.ContestEntry;
import mk.com.codehelp.core.rest.model.ContestProblem;
import mk.com.codehelp.core.service.dto.ContestDto;
import mk.com.codehelp.core.service.dto.ContestProblemDto;

import java.util.Collection;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, ProblemMapper.class, DateTimeMapper.class})
public interface ContestMapper {

  List<ContestEntry> convert(Collection<ContestValue> contests);

  ContestEntry convert(ContestDto contest);

  ContestProblem convert(ContestProblemDto contestProblemDto);

  ContestStatus convert(mk.com.codehelp.core.rest.model.ContestStatus status);
}
