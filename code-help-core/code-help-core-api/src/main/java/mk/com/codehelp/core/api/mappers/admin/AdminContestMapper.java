package mk.com.codehelp.core.api.mappers.admin;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.admin.model.*;

import java.util.Collection;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper
public interface AdminContestMapper {

  mk.com.codehelp.core.rest.admin.model.Contest convertPrivate(Contest contest);

  List<mk.com.codehelp.core.rest.admin.model.Contest> convert(Collection<Contest> problems);

  @Mapping(target = ".", source = "problem")
  @Mapping(target = "contestProblemId", source = "id")
  ContestProblem convert(mk.com.codehelp.core.domain.model.relations.ContestProblem contestProblem);

  ContestDetail convert(Contest contest);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "problems", ignore = true)
  Contest convert(ContestRequest contest);

  Contest convert(Long id, ContestEditRequest contestEditRequest);

  @Mapping(target = "id", source = "contestProblemId")
  @Mapping(target = "problem", ignore = true)
  mk.com.codehelp.core.domain.model.relations.ContestProblem convert(ContestProblemEditRequest contestProblemEdit);
}
