package mk.com.codehelp.core.service.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Builder;
import lombok.Getter;

import mk.com.codehelp.core.domain.enums.ContestStatus;

@Getter
@Builder
public class ContestDto {

  private Long id;
  private String name;
  private String description;
  private String duration;
  private LocalDateTime startDate;
  private ContestStatus status;
  private Long participants;
  private List<ContestProblemDto> problems;
}
