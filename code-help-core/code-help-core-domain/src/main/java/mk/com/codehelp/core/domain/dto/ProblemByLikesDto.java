package mk.com.codehelp.core.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.File;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProblemByLikesDto {
  private Long id;
  private Category category;
  private String title;
  private Difficulty difficulty;
  private String markdown;
  private File starterCode;
  private File runnerCode;
  private List<File> testCases = new ArrayList<>();
  private Long likes;
}
