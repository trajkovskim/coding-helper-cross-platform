package mk.com.codehelp.core.service.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CodeRunnerDto {

  private String message;
  private boolean error;
  private Integer testCasesPassed;
}
