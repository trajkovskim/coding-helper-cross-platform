package mk.com.codehelp.core.service.exceptions;

import mk.com.codehelp.core.domain.enums.ContestStatus;

public class ContestStatusException extends RuntimeException {

  public ContestStatusException(Long id, ContestStatus status) {
    super("Contest with id " + id + " doesn't have status " + status.name());
  }
}
