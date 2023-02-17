package mk.com.codehelp.core.domain.queries;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserWithTotalSolvedQuery {
  private String user;
  private Long solved;
}
