package mk.com.codehelp.core.domain.model.filter;

import java.util.Collection;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProblemFilter {
  private Collection<String> categories;
  private String likedBy;

  public String getLikedBy() {
    if (likedBy == null) {
      return "";
    }

    return likedBy;
  }

  public Collection<String> getCategories() {
    if(categories == null) {
      return Set.of();
    }

    return categories;
  }
}
