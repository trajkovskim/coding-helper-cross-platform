package mk.com.codehelp.core.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.ContestProblem;
import mk.com.codehelp.core.domain.enums.ContestStatus;

import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContestDto {
  private Long id;
  private String name;
  private String duration;
  private Date startsOn;
  private ContestStatus status;

  List<ContestProblem> problems;

  public ContestDto(Contest contest) {
    this.id = contest.getId();
    this.name = contest.getName();
    this.duration = contest.getDuration();
    this.startsOn = contest.getStartsOn();
    this.status = contest.getStatus();
    this.problems = contest.getProblems();
  }
}
