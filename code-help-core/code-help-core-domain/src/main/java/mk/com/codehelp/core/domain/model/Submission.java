package mk.com.codehelp.core.domain.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;

import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

@Data
@NoArgsConstructor
@Node
public class Submission {

  @Id
  @GeneratedValue
  private Long id;

  @CreatedDate
  private LocalDateTime createdDate;
  private SubmissionStatus status;
  private String language;
  private String code;
  private Integer testCasesPassed;
  private Integer testCasesCount;

  @CreatedBy
  @Relationship(value = "BY", direction = Relationship.Direction.INCOMING)
  private User user;

  @Relationship(value = "FOR_PROBLEM", direction = Relationship.Direction.OUTGOING)
  private Problem problem;

  public Submission(SubmissionStatus status, String language, String code, Problem problem, Integer testCasesPassed, Integer testCasesCount) {
    this.status = status;
    this.language = language;
    this.code = code;
    this.problem = problem;
    this.testCasesPassed = testCasesPassed;
    this.testCasesCount = testCasesCount;
  }
}
