package mk.com.codehelp.core.domain.model.value.relations;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import mk.com.codehelp.core.domain.model.value.ProblemValue;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContestProblemValue {

  private Long id;
  private ProblemValue problem;
  private Integer score;
}
