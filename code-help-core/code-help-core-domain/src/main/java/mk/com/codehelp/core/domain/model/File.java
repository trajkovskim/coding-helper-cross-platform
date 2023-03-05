package mk.com.codehelp.core.domain.model;


import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;

@Node
@Data
@NoArgsConstructor
public class File {
  @Id
  @GeneratedValue
  private Long id;
  private String name;
  private String type;
  private byte[] data;
}
