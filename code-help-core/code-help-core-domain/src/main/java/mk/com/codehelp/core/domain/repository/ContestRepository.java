package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Contest;
import org.springframework.data.neo4j.repository.Neo4jRepository;

public interface ContestRepository extends Neo4jRepository<Contest, Long> {
}
