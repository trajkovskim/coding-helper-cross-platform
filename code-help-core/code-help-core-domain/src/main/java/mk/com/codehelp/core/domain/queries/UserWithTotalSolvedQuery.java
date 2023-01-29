package mk.com.codehelp.core.domain.queries;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.model.User;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserWithTotalSolvedQuery {
  private User user;
  private Long solved;
}
