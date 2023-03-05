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

  @Relationship(value = "IN_CATEGORY", direction = Relationship.Direction.OUTGOING)
  private Category category;

  private String title;

  private Difficulty difficulty;

  private String markdown;

  private List<String> likedBy = new ArrayList<>();

  @Relationship(value = "STARTER_CODE", direction = Relationship.Direction.OUTGOING)
  private File starterCode;

  @Relationship(value = "RUNNER_CODE", direction = Relationship.Direction.OUTGOING)
  private File runnerCode;

  @Relationship(value = "TEST_CASES", direction = Relationship.Direction.OUTGOING)
  private List<File> testCases = new ArrayList<>();

}
