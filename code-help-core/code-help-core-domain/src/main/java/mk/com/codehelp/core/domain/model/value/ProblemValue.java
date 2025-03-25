package mk.com.codehelp.core.domain.model.value;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProblemValue {

  private Long id;
  private Category category;
  private String title;
  private Difficulty difficulty;
  private String markdown;
  private List<Problem.Code> starterCodes;
  private List<Problem.Code> runnerCodes;
  private List<Problem.TestCase> testCases = new ArrayList<>();
  private Long likes;
}
