package mk.com.codehelp.core.domain.model.filter;

import lombok.Getter;
import lombok.Setter;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;

@Getter
@Setter
public class SubmissionFilter {

  private String userId;
  private SubmissionStatus status;

  public String getStatus() {
    if (status == null) {
      return "";
    }

    return status.toString();
  }
}
