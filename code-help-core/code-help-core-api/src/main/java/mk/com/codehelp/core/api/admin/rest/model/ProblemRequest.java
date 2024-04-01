package mk.com.codehelp.core.api.admin.rest.model;

import lombok.Builder;
import lombok.Getter;
import mk.com.codehelp.core.rest.admin.model.Category;
import mk.com.codehelp.core.rest.admin.model.Difficulty;
import org.springframework.core.io.Resource;

import java.util.List;

@Getter
@Builder
public class ProblemRequest {

  private Category category;
  private String title;
  private Difficulty difficulty;
  private String markdown;
  private Resource starterCode;
  private Resource runnerCode;
  private List<Resource> testCases;
}
