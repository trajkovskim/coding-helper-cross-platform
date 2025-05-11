package mk.com.codehelp.core;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.neo4j.config.EnableNeo4jAuditing;
import org.springframework.data.neo4j.repository.config.EnableNeo4jRepositories;

@SpringBootApplication
@EnableNeo4jRepositories
@EnableNeo4jAuditing
public class CodingHelperApplication {
  public static void main(String[] args) {
    SpringApplication.run(CodingHelperApplication.class, args);
  }
}