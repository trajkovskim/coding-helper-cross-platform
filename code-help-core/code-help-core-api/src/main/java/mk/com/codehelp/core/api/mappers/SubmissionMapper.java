package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.SubmissionDto;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
import mk.com.codehelp.core.rest.model.SubmissionsResponse;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface SubmissionMapper {

  //  SubmissionDto toDto(Submission submission);
  List<SubmissionEntry> convertListOfSubmissionModel(List<SubmissionDto> submissions);

  default SubmissionsResponse convertListOfSubmissionToResponse(List<SubmissionDto> submissions) {
    List<SubmissionEntry> entries = convertListOfSubmissionModel(submissions);
    return new SubmissionsResponse().submissions(entries);
  }

}
