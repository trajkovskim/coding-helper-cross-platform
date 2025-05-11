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
  private String name;
  private String description;
  private Difficulty difficulty;
  private String markdown;
  private Long likes;
  private List<Problem.Code> codes = new ArrayList<>();
  private List<Problem.TestCase> testCases = new ArrayList<>();
}
