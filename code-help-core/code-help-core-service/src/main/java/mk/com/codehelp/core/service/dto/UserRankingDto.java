package mk.com.codehelp.core.service.dto;

import lombok.Builder;
import lombok.Getter;

import mk.com.codehelp.core.domain.model.User;

@Getter
@Builder
public class UserRankingDto {

  private User user;
  private Long ranking;
  private Long score;
}
