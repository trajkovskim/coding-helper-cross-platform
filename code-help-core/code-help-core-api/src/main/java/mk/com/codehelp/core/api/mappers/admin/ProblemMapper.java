package mk.com.codehelp.core.api.mappers.admin;

import mk.com.codehelp.core.api.admin.rest.model.ProblemRequest;
import mk.com.codehelp.core.api.mappers.FileMapper;
import mk.com.codehelp.core.rest.admin.model.Problem;
import mk.com.codehelp.core.rest.admin.model.ProblemDetail;
import mk.com.codehelp.core.rest.admin.model.ProblemResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(uses = {FileMapper.class})
public interface ProblemMapper {

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "likedBy", ignore = true)
  mk.com.codehelp.core.domain.model.Problem convert(ProblemRequest problem);

  @Mapping(target = "likedBy", ignore = true)
  mk.com.codehelp.core.domain.model.Problem convert(Long id, ProblemRequest problem);

  Problem convertPrivate(mk.com.codehelp.core.domain.model.Problem problem);

  default ProblemResponse convert(List<mk.com.codehelp.core.domain.model.Problem> problems) {

    return new ProblemResponse().problems(
        problems.stream().map(this::convertPrivate).collect(Collectors.toList()));
  }

  ProblemDetail convert(mk.com.codehelp.core.domain.model.Problem problem);
}
