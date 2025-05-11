package mk.com.codehelp.core.domain.model.filter;

import lombok.Getter;
import lombok.Setter;

import mk.com.codehelp.core.domain.enums.ContestStatus;

@Setter
@Getter
public class ContestFilter {

  private String name;
  private ContestStatus status;

  public String getName() {
    if (name == null) {
      return "";
    }

    return name + ".*";
  }

  public String getStatus() {
    if (status == null) {
      return "";
    }

    return status.toString();
  }
}
