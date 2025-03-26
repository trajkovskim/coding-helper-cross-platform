package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Repository;

@Repository
public interface ProblemRepository extends Neo4jRepository<Problem, Long> {

  @Query(value = """
      match (problem:Problem)
      optional match (problem)-[r_contest]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(starter_code)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(runner_code)
      optional match (problem)-[r_test_cases:TEST_CASES]->(test_cases)
      with problem as problem,
        contest as node_contest,
        category as node_category,
      collect(r_category) as r_category, collect(category) as category,
      collect(r_starter_code) as r_starter_codes, collect(starter_code) as starterCodes,
      collect(r_runner_code) as r_runner_codes, collect(runner_code) as runnerCodes,
      collect(r_test_cases) as r_test_cases, collect(test_cases) as testCases,
      size(problem.likedBy) as likes
      where (node_contest is null or node_contest.status='CLOSED')
        and (:#{#filters.categories.size} = 0 or node_category.name in :#{#filters.categories})
        and (:#{#filters.likedBy.length} = 0 or :#{#filters.likedBy} in problem.likedBy)
      return *
        :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""", countQuery = """
      match (problem:Problem)
      optional match (problem)-[r_contest]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(starter_code)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(runner_code)
      optional match (problem)-[r_test_cases:TEST_CASES]->(test_cases)
      with problem as problem,
        contest as node_contest,
        category as node_category,
      collect(r_category) as r_category, collect(category) as category,
      collect(r_starter_code) as r_starter_codes, collect(starter_code) as starterCodes,
      collect(r_runner_code) as r_runner_codes, collect(runner_code) as runnerCodes,
      collect(r_test_cases) as r_test_cases, collect(test_cases) as testCases
      where (node_contest is null or node_contest.status='CLOSED')
        and (:#{#filters.categories.size} = 0 or node_category.name in :#{#filters.categories})
        and (:#{#filters.likedBy.length} = 0 or :#{#filters.likedBy} in problem.likedBy)
      return count(*)""")
  Page<ProblemValue> findAll(ProblemFilter filters, Pageable pageable);

  @Override
  @Query("""
      match (problem:Problem)
      optional match (problem)<-[r_submission:FOR_PROBLEM]-(submission:Submission)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(starter_code)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(runner_code)
      optional match (problem)-[r_test_cases:TEST_CASES]->(test_cases)
      with problem, starter_code, runner_code, test_cases, submission
      where ID(problem)=$id
      detach delete problem, file_starter_code, file_runner_code, file_test_cases, submission""")
  void deleteById(@NonNull Long id);

  boolean existsByIdAndLikedByContains(Long id, String likedBy);
}
