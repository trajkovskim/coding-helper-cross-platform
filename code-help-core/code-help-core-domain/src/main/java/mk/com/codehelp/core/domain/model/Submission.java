package mk.com.codehelp.core.domain.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
@NoArgsConstructor
@Node
public class Submission {
  @Id
  @GeneratedValue
  private Long id;
  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private Date timeSubmitted;
  private SubmissionStatus status;
  private String language;
  private String code;

  private String user;

  @Relationship(value = "FOR_PROBLEM", direction = Relationship.Direction.OUTGOING)
  private Problem problem;

  public Submission(Date timeSubmitted, SubmissionStatus status, String language, String code, String user, Problem problem) {
    this.timeSubmitted = timeSubmitted;
    this.status = status;
    this.language = language;
    this.code = code;
    this.user = user;
    this.problem = problem;
  }
}
