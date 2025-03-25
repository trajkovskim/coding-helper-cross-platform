package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
import mk.com.codehelp.core.rest.model.SubmissionsResponse;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface SubmissionMapper {

  List<SubmissionEntry> convertListOfSubmissionModel(List<SubmissionValue> submissions);

  default SubmissionsResponse convertListOfSubmissionToResponse(List<SubmissionValue> submissions) {
    List<SubmissionEntry> entries = convertListOfSubmissionModel(submissions);
    return new SubmissionsResponse().submissions(entries);
  }
}
