package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.admin.model.TestCase;
import mk.com.codehelp.core.rest.model.ProblemEntry;
import mk.com.codehelp.core.rest.model.ProblemEntryDetail;
import mk.com.codehelp.core.rest.model.ProblemsResponse;
import mk.com.codehelp.core.service.dto.ProblemDto;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(uses = {CategoryMapper.class})
public interface ProblemMapper {

  @Mapping(target = "starterCode", source = "starterCode.code")
  ProblemEntryDetail convertProblem(ProblemDto problemDto);

  List<ProblemEntry> convertListOfProblemToRest(List<ProblemValue> problem);

  default ProblemsResponse convertListOfProblemToResponse(List<ProblemValue> problems) {
    List<ProblemEntry> entries = convertListOfProblemToRest(problems);
    return new ProblemsResponse().problems(entries);
  }

  Problem.TestCase convert(TestCase testCase);
}
