package mk.com.codehelp.core.domain.model.value;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import mk.com.codehelp.core.domain.model.User;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserRankingValue {

  private User user;
  private Long score;
}
