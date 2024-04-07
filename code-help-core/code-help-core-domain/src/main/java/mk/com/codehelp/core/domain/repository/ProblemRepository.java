package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.Problem;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface ProblemRepository extends Neo4jRepository<Problem, Long> {
  @Override
  @Query("""
      match (problem:Problem)
      optional match (problem)-[r_contest]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File)
      optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File)
      with problem as problem,
      contest as node_contest,
      collect(r_category) as r_category, collect(category) as category,
      collect(r_starter_code) as r_starter_code, collect(file_starter_code) as starterCode,
      collect(r_runner_code) as r_runner_code, collect(file_runner_code) as runnerCode,
      collect(r_test_cases) as r_test_cases, collect(file_test_cases) as testCases
      where node_contest is null or node_contest.status='CLOSED'
      return *""")
  List<Problem> findAll();

  @Query("""
      match (problem:Problem)
      optional match (problem)-[r_contest:IN_CONTEST]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File)
      optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File)
      with problem as node_problem,
      contest as node_contest,
      category as node_category,
      collect(r_category) as r_category, collect(category) as category,
      collect(r_starter_code) as r_starter_code, collect(file_starter_code) as starterCode,
      collect(r_runner_code) as r_runner_code, collect(file_runner_code) as runnerCode,
      collect(r_test_cases) as r_test_cases, collect(file_test_cases) as testCases
      where (node_contest is null or node_contest.status='CLOSED') and node_category.name in $categories
      return *""")
  List<Problem> findAllByCategory_NameIn(Collection<String> categories);

  @Query("""
      match (problem:Problem)
      optional match (problem)-[r_contest:IN_CONTEST]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File)
      optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File)
      with problem as node_problem,
      contest as node_contest,
      category as node_category,
      collect(r_category) as r_category, collect(category) as category,
      collect(r_starter_code) as r_starter_code, collect(file_starter_code) as starterCode,
      collect(r_runner_code) as r_runner_code, collect(file_runner_code) as runnerCode,
      collect(r_test_cases) as r_test_cases, collect(file_test_cases) as testCases,
      size(problem.likedBy) as likes
      where node_contest is null or node_contest.status='CLOSED'
      return *
      order by likes desc limit 10""")
  List<ProblemByLikesDto> findTop10ByOrderByLikes();

  @Override
  @Query("""
      match (problem:Problem)
      optional match (problem)<-[r_submission:FOR_PROBLEM]-(submission:Submission)
      optional match (problem)-[r_starter_code:STARTER_CODE]->(file_starter_code:File)
      optional match (problem)-[r_runner_code:RUNNER_CODE]->(file_runner_code:File)
      optional match (problem)-[r_test_cases:TEST_CASES]->(file_test_cases:File)
      with problem, file_starter_code, file_runner_code, file_test_cases, submission
      where ID(problem)=$id
      detach delete problem, file_starter_code, file_runner_code, file_test_cases, submission""")
  void deleteById(@NonNull Long id);
}
