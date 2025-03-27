package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.rest.model.SubmissionEntry;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface SubmissionMapper {

  List<SubmissionEntry> convert(List<SubmissionValue> submissions);
}
