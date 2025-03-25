package mk.com.codehelp.core.service.dto;

import lombok.Getter;
import lombok.experimental.SuperBuilder;

@Getter
@SuperBuilder
public class ContestProblemDto extends ProblemDto {

  private Long score;
}
