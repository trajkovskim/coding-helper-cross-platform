package mk.com.codehelp.core.service.dto;

import lombok.Builder;
import lombok.Getter;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;

@Getter
@Builder
public class CreatedSubmissionDto {

  private SubmissionStatus status;
  private String message;
}
