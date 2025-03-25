package mk.com.codehelp.core.domain.model.value;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Problem;

import java.util.Date;

@NoArgsConstructor
@Data
public class SubmissionValue {

  private Long id;
  private Date timeSubmitted;
  private SubmissionStatus status;
  private String language;
  private String code;

  private Problem problem;
}
