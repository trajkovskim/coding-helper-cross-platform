package mk.com.codehelp.core.domain.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.ContestStatus;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;

import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Node
@Data
@NoArgsConstructor
public class Contest {

  @Id
  @GeneratedValue
  private Long id;
  private String name;
  private String duration;
  private Date startsOn;
  private ContestStatus status;

  @Relationship(value = "IN_CONTEST", direction = Relationship.Direction.INCOMING)
  List<ContestProblem> problems = new ArrayList<>();
}
