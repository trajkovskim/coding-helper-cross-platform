package mk.com.codehelp.core.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserStatisticsDto {
  private Long solved;
  private Long easy;
  private Long medium;
  private Long hard;
}
