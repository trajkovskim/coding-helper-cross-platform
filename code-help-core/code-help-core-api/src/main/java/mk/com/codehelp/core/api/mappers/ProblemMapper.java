package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.admin.model.TestCase;
import mk.com.codehelp.core.rest.model.ProblemEntry;
import mk.com.codehelp.core.rest.model.ProblemEntryBase;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.dto.ProblemEmbeddedDto;

import java.util.Collection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, DateTimeMapper.class})
public interface ProblemMapper {

  @Mapping(target = "starterCode", source = "code.starter")
  ProblemEntry convert(ProblemDto problemDto);

  List<ProblemEntryBase> convert(Collection<ProblemDto> problem);

  @Mapping(target = "id", ignore = true)
  Problem.TestCase convert(TestCase testCase);

  Difficulty convert(mk.com.codehelp.core.rest.model.Difficulty difficulty);
}
