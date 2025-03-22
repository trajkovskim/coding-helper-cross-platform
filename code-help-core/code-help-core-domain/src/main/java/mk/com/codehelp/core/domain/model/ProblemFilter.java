package mk.com.codehelp.core.domain.model;

import java.util.Collection;
import java.util.HashSet;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProblemFilter {

  private Collection<String> categories = new HashSet<>();
  private String user;
}
