package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.model.ProblemEntry;
import mk.com.codehelp.core.rest.model.ProblemsResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, FileMapper.class})
public interface ProblemMapper {

  @Mapping(target = "likes", expression = "java((long) (problem.getLikedBy().size()))")
  ProblemEntry convertProblem(Problem problem);

  List<ProblemEntry> convertListOfProblemToRest(List<ProblemByLikesDto> problem);

  ProblemEntry convertProblemByLikes(ProblemByLikesDto problem);

  default ProblemsResponse convertListOfProblemToResponse(List<ProblemByLikesDto> problems) {
    List<ProblemEntry> entries = convertListOfProblemToRest(problems);
    return new ProblemsResponse().problems(entries);
  }
}
