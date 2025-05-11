package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.value.CategoryValue;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends Neo4jRepository<Category, Long> {

  Optional<Category> findByName(String name);

  @Query("""
    match (category:Category)
    optional match (category)-[r_problem:IN_CATEGORY]-(problem:Problem)
    return category, count(problem) as problemsCount""")
  List<CategoryValue> findAllCategories();
}
