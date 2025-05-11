package mk.com.codehelp.core.domain.model.value;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Problem;

import java.time.LocalDateTime;
import java.util.Date;

@NoArgsConstructor
@Data
public class SubmissionValue {

  private Long id;
  private LocalDateTime createdDate;
  private SubmissionStatus status;
  private String language;
  private String code;
}
