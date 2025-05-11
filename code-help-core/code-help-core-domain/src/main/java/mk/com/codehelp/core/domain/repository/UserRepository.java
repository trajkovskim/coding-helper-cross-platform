package mk.com.codehelp.core.domain.repository;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import mk.com.codehelp.core.domain.model.User;

@Repository
public interface UserRepository extends Neo4jRepository<User, String> {
}
