package mk.com.codehelp.core.domain.model;

import java.io.Serial;
import java.io.Serializable;

import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Node
public class User implements Serializable {

  @Serial
  private static final long serialVersionUID = 1L;

  @Id
  private String userId;
  private String username;
}
