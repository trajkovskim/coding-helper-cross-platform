package mk.com.codehelp.core.domain.repository;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.neo4j.config.EnableNeo4jAuditing;
import org.springframework.data.neo4j.repository.config.EnableNeo4jRepositories;

@ComponentScan(basePackages = "mk.com.codehelp.core.domain")
@EnableAutoConfiguration
@EnableNeo4jAuditing
@EnableNeo4jRepositories
public class RepositoryTestConfiguration {
}
