package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.model.ProblemByLikes;
import mk.com.codehelp.core.rest.model.ProblemEntry;
import mk.com.codehelp.core.rest.model.ProblemsResponse;
import mk.com.codehelp.core.rest.model.ProblemsTop10Response;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(uses = {CategoryMapper.class, FileMapper.class})
public interface ProblemMapper {

  ProblemEntry convertProblem(Problem problem);

  List<ProblemEntry> convertListOfProblemToRest(List<Problem> problem);

  ProblemByLikes convertProblemByLikes(ProblemByLikesDto problem);

  @Mapping(target = "likes", expression = "java((long) (problem.getLikedBy().size()))")
  ProblemByLikes convertProblemByLikes(Problem problem);

  List<ProblemByLikes> convertListOfProblemByLikesToRest(List<ProblemByLikesDto> problems);

  default ProblemsResponse convertListOfProblemToResponse(List<Problem> problems) {
    List<ProblemEntry> entries = convertListOfProblemToRest(problems);
    return new ProblemsResponse().problems(entries);
  }

  default ProblemsTop10Response convertListOfProblemByLikesToResponse(List<ProblemByLikesDto> problems) {
    List<ProblemByLikes> entries = convertListOfProblemByLikesToRest(problems);
    return new ProblemsTop10Response().problems(entries);
  }
}
