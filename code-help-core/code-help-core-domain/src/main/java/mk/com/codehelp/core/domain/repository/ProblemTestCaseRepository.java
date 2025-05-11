package mk.com.codehelp.core.domain.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import mk.com.codehelp.core.domain.model.Problem;

@Repository
public interface ProblemTestCaseRepository extends Neo4jRepository<Problem.TestCase, Long> {

  @Query(value = """
    match (test_case:TestCase)<-[r_test_case]-(problem:Problem)
    where ID(problem) = $problemId
    return test_case :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""",
  countQuery = """
    match (testCase:TestCase)<-[r_test_case]-(problem:Problem)
    where ID(problem) = $problemId
    return count(test_case)""")
  Page<Problem.TestCase> findAllByProblem(Long problemId, Pageable pageable);
}
