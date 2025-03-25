package mk.com.codehelp.core.service.dto;

import lombok.Getter;
import lombok.experimental.SuperBuilder;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;

@Getter
@SuperBuilder
public class ProblemDto {

  private Long id;
  private Category category;
  private String title;
  private Difficulty difficulty;
  private String markdown;
  private Problem.Code starterCode;
  private Problem.Code runnerCode;
  private Long likes;
}
