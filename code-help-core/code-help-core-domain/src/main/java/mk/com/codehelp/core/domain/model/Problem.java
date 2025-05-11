package mk.com.codehelp.core.domain.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.Difficulty;

import org.springframework.data.neo4j.core.schema.*;

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

  private String name;

  private String description;

  private Difficulty difficulty;

  private String markdown;

  @Relationship(value = "LIKES", direction = Relationship.Direction.INCOMING)
  private List<User> likedBy = new ArrayList<>();

  @Relationship(value = "CODE", direction = Relationship.Direction.OUTGOING)
  private List<Code> codes = new ArrayList<>();

  @Relationship(value = "TEST_CASES", direction = Relationship.Direction.OUTGOING)
  private List<TestCase> testCases = new ArrayList<>();

  @Node
  @Data
  public static class Code {

    @Id
    @GeneratedValue
    private Long id;
    private String language;
    private String starter;
    private String runner;
  }

  @Data
  @Node
  public static class TestCase {

    @Id
    @GeneratedValue
    private Long id;
    private String in;
    private String out;
  }
}
