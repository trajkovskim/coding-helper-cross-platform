package mk.com.codehelp.core.domain.model.filter;

import java.util.Collection;
import java.util.Set;

import lombok.Getter;
import lombok.Setter;

import mk.com.codehelp.core.domain.enums.Difficulty;

@Setter
@Getter
public class ProblemFilter {

  private Long id;
  private Collection<String> categories;
  private String likedBy;
  private String name;
  private Difficulty difficulty;

  public Long getId() {
    if (id == null) {
      return -1L;
    }

    return id;
  }

  public String getName() {
    if (name == null) {
      return "";
    }

    return name + ".*";
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
