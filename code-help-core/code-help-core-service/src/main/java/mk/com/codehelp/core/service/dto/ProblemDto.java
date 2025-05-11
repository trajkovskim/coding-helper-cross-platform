package mk.com.codehelp.core.service.dto;

import java.util.List;

import lombok.Getter;
import lombok.experimental.SuperBuilder;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;

@Getter
@SuperBuilder
public class ProblemDto {

  private Long id;
  private Category category;
  private String name;
  private String description;
  private Difficulty difficulty;
  private String markdown;
  private Long likes;
  private Problem.Code code;
  private List<Problem.TestCase> testCases;
  private SubmissionValue lastSubmission;
  private SubmissionValue lastAcceptedSubmission;
}
