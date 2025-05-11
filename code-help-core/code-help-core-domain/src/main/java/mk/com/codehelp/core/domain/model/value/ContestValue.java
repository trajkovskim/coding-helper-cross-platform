package mk.com.codehelp.core.domain.model.value;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import mk.com.codehelp.core.domain.enums.ContestStatus;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContestValue {

  private Long id;
  private String name;
  private String description;
  private String duration;
  private LocalDateTime startDate;
  private ContestStatus status;
  private Long participantsSize;
}
