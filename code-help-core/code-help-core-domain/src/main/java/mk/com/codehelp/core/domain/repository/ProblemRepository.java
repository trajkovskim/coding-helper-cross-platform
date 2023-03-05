package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.queries.ProblemByLikesQuery;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface ProblemRepository extends Neo4jRepository<Problem, Long> {
  @Override
  @Query("match (problem:Problem) " +
      "optional match (problem)-[r_contest]-(contest:Contest) " +
      "where contest is null or contest.status='CLOSED' with problem " +
      "optional match (problem)-[r_category:IN_CATEGORY]->(category:Category) " +
      "optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File) " +
      "optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File) " +
      "optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File) " +
      "return problem, " +
      "collect(r_category), collect(category) as category, " +
      "collect(r_starter_code), collect(file_starter_code) as starterCode, " +
      "collect(r_runner_code), collect(file_runner_code) as runnerCode, " +
      "collect(r_test_cases), collect(file_test_cases) as testCases")
  List<Problem> findAll();

  @Query("match (problem)-[r:WITH_CATEGORY]->(category:Category) " +
      "where category.name in $categories " +
      "optional match (problem)-[r_contest]-(contest:Contest) " +
      "where contest is null or contest.status='CLOSED' with problem " +
      "optional match (problem)-[r_category:IN_CATEGORY]->(category:Category) " +
      "optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File) " +
      "optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File) " +
      "optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File) " +
      "return problem, " +
      "collect(r_category), collect(category) as category, " +
      "collect(r_starter_code), collect(file_starter_code) as starterCode, " +
      "collect(r_runner_code), collect(file_runner_code) as runnerCode, " +
      "collect(r_test_cases), collect(file_test_cases) as testCases")
  List<Problem> findAllByCategory_NameIn(Collection<String> categories);

    @Query("match (p:Problem) " +
            "optional match (p)-[r:IN_CONTEST]->(c:Contest) with p, c where c is null or c.status='CLOSED' " +
            "optional match (p)-[r:LIKED_BY]->(m:User) with p as problem, count(r) as likes return problem, likes order by likes desc")
    List<ProblemByLikesQuery> findTop10ByOrderByLikes();

  @Override
  @Query("match (problem:Problem) with problem " +
      "optional match (problem)<-[r:PROBLEM]-(submission:Submission) with problem, submission " +
      "match (problem:Problem) where ID(problem)=$id detach delete problem, submission")
  void deleteById(Long id);
}
