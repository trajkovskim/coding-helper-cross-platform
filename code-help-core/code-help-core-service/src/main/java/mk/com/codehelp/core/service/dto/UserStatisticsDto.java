package mk.com.codehelp.core.service.dto;

import lombok.*;

@Getter
@Builder
public class UserStatisticsDto {

  private Long solved;
  private Long easy;
  private Long medium;
  private Long hard;
}
