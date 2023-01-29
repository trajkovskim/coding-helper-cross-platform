package mk.com.codehelp.core.domain.model;

import lombok.Data;
import org.springframework.data.neo4j.core.schema.RelationshipId;
import org.springframework.data.neo4j.core.schema.RelationshipProperties;
import org.springframework.data.neo4j.core.schema.TargetNode;

@Data
@RelationshipProperties
public class ContestProblem {
  @RelationshipId
  private Long id;

  @TargetNode
  private Problem problem;

  private Long score;

  public ContestProblem(Problem problem, Long score) {
    this.problem = problem;
    this.score = score;
  }
}
