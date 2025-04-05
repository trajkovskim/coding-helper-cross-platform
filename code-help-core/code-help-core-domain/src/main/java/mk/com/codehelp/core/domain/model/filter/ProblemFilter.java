package mk.com.codehelp.core.domain.model.filter;

import java.util.Collection;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

import mk.com.codehelp.core.domain.enums.Difficulty;

@Setter
@Getter
public class ProblemFilter {

  private Collection<String> categories;
  private String likedBy;
  private String title;
  private Difficulty difficulty;

  public String getTitle() {
    if (title == null) {
      return "";
    }

    return title + ".*";
  }

  public String getDifficulty() {
    if (difficulty == null) {
      return "";
    }

    return difficulty.toString();
  }

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
