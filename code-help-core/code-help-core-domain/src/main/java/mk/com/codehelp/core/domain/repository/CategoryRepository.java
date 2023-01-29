package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Category;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends Neo4jRepository<Category, String> {
}
