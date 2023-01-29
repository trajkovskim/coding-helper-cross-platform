package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.queries.ProblemByLikesQuery;
import mk.com.codehelp.core.rest.model.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Mapper(uses = {CategoryMapper.class, DifficultyMapper.class})
public interface ProblemMapper {

  @Mappings({
      @Mapping(source = "starterCode", target = ".", qualifiedByName = "convertResource"),
  })
  Problem convertProblem(ProblemRequest problem);


  default String convertResource(Resource resource) throws IOException {
    byte[] data = resource.getInputStream().readAllBytes();
    return new String(data, StandardCharsets.UTF_8);
  }

  ProblemEntry convertProblem(Problem problem);

  List<ProblemEntry> convertListOfProblemToRest(List<Problem> problem);

  ProblemByLikes convertProblemByLikes(ProblemByLikesQuery problem);

  List<ProblemByLikes> convertListOfProblemByLikesToRest(List<ProblemByLikesQuery> problems);

  default ProblemsResponse convertListOfProblemToResponse(List<Problem> problems) {
    List<ProblemEntry> entries = convertListOfProblemToRest(problems);
    return new ProblemsResponse().problems(entries);
  }

  default ProblemsTop10Response convertListOfProblemByLikesToResponse(List<ProblemByLikesQuery> problems) {
    List<ProblemByLikes> entries = convertListOfProblemByLikesToRest(problems);
    return new ProblemsTop10Response().problems(entries);
  }
}
