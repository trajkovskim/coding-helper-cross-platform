package mk.com.codehelp.core.domain.model.value;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class CategoryValue {

  private Long id;
  private String name;
  private String description;
  private Long problemsCount;
}
