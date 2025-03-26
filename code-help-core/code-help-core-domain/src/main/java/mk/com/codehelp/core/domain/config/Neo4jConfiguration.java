package mk.com.codehelp.core.domain.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.neo4j.core.convert.Neo4jConversions;

import mk.com.codehelp.core.domain.ProblemFilterToValueConverter;

@Configuration
public class Neo4jConfiguration {

  @Bean
  public Neo4jConversions neo4jConversions() {
    return new Neo4jConversions(List.of(new ProblemFilterToValueConverter()));
  }
}
