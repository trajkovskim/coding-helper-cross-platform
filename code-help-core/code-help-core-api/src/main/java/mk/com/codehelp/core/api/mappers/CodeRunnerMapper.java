package mk.com.codehelp.core.api.mappers;

import org.mapstruct.Mapper;

import mk.com.codehelp.core.rest.model.CodeRunnerResponse;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;

@Mapper
public interface CodeRunnerMapper {

  CodeRunnerResponse convert(CodeRunnerDto dto);
}
