package mk.com.codehelp.core.api.mappers.admin;

import mk.com.codehelp.core.rest.admin.model.Problem;
import mk.com.codehelp.core.rest.admin.model.ProblemDetail;
import mk.com.codehelp.core.rest.admin.model.ProblemRequest;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.dto.ProblemEmbeddedDto;

import java.util.Collection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper
public interface AdminProblemMapper {

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "likedBy", ignore = true)
  mk.com.codehelp.core.domain.model.Problem convert(ProblemRequest problem);

  @Mapping(target = "likedBy", ignore = true)
  mk.com.codehelp.core.domain.model.Problem convert(Long id, ProblemRequest problem);

  List<Problem> convert(Collection<ProblemDto> problems);

  ProblemDetail convert(mk.com.codehelp.core.domain.model.Problem problem);
}
