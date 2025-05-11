package mk.com.codehelp.core.domain.model.value;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class SubmissionByLanguageCountPairsValue {

  private String language;
  private Long count;
}
