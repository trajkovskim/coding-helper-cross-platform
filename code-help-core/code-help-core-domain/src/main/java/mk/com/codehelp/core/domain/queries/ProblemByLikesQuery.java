package mk.com.codehelp.core.domain.queries;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.model.Problem;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProblemByLikesQuery {
  private Problem problem;
  private Long likes;
}
