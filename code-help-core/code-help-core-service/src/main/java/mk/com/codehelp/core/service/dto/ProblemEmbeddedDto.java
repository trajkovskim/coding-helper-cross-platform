package mk.com.codehelp.core.service.dto;

import lombok.Builder;
import lombok.Getter;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;

@Getter
@Builder(toBuilder = true)
public class ProblemEmbeddedDto {

  private Long id;
  private Category category;
  private String name;
  private String description;
  private Difficulty difficulty;
  private String markdown;
  private Long likes;
  private SubmissionValue lastSubmission;
  private SubmissionValue lastAcceptedSubmission;
}
