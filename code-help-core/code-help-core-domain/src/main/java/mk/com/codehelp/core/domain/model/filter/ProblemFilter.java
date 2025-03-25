package mk.com.codehelp.core.domain.model.filter;

import java.util.Collection;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProblemFilter {

  private Collection<String> categories;
  private String likedBy;
}
