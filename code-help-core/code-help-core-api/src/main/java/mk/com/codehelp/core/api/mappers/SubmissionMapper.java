package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.model.CreatedSubmissionResponse;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;

import org.mapstruct.Mapper;

import java.util.List;
import org.mapstruct.Mapping;

@Mapper
public interface SubmissionMapper {

  List<SubmissionEntry> convert(List<SubmissionValue> submissions);

  @Mapping(target = "links", ignore = true)
  CreatedSubmissionResponse convert(CreatedSubmissionDto createdSubmissionDto);
}
