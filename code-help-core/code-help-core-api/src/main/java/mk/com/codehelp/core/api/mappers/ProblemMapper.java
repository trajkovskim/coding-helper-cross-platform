package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.File;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.rest.model.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.boot.web.server.MimeMappings;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Mapper(uses = {CategoryMapper.class, DifficultyMapper.class})
public interface ProblemMapper {

  default File convertResourceToFile(Resource resource) throws IOException {
    String type = "unknown";

    int index = resource.getFilename().lastIndexOf(".");
    if (index != -1) {
      String extension = resource.getFilename().substring(index + 1);
      type = MimeMappings.DEFAULT.get(extension);
    }

    File file = new File();
    file.setName(resource.getFilename());
    file.setType(type);
    file.setData(resource.getInputStream().readAllBytes());

    return file;
  }

  default String convertDomainFileToString(File file) throws IOException {
    return new String(file.getData(), StandardCharsets.UTF_8);
  }

  Problem convertProblem(ProblemRequest problem);

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
