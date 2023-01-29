package mk.com.codehelp.core.domain.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.Difficulty;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.List;

@Node
@Data
@NoArgsConstructor
public class Problem {
  @Id
  @GeneratedValue
  private Long id;
  @Relationship(value = "WITH_CATEGORY")
  private Category category;
  private String title;
  private Difficulty difficulty;
  private String markdown;
  private String starterCode;

  @Relationship(value = "LIKED_BY")
  private List<User> likedBy;

  public Problem(Category category, String title, Difficulty difficulty, String markdown, String starterCode) {
    this.category = category;
    this.title = title;
    this.difficulty = difficulty;
    this.markdown = markdown;
    this.starterCode = starterCode;
    this.likedBy = new ArrayList<>();
  }
}
