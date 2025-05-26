package mk.com.codehelp.core.domain.repository;

import java.util.Optional;

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
      optional match (problem)-[r_code:CODE]->(code:Code)
      optional match (problem)-[r_test_case:TEST_CASES]->(test_case:TestCase)
      optional match (problem)<-[r_user:LIKES]-(user:User)
      with problem,
        contest as node_contest,
        category, r_category,
        user, r_user,
        collect(r_code) as r_codes, collect(code) as codes,
        collect(r_test_case)[0..3] as r_test_cases, collect(test_case)[0..3] as testCases,
        collect(r_user) as r_users
      with problem,
        node_contest,
        category, r_category,
        user, r_user,
        r_codes, codes,
        r_test_cases, testCases,
        count(r_users) as likes
      where (node_contest is null or node_contest.status='CLOSED')
        and (:#{#filters.id} = -1 or ID(problem) = :#{#filters.id})
        and (:#{#filters.name.length} = 0 or problem.name =~ :#{#filters.name})
        and (:#{#filters.categories.size} = 0 or category.name in :#{#filters.categories})
        and (:#{#filters.likedBy.length} = 0 or :#{#filters.likedBy} = user.userId)
        and (:#{#filters.difficulty.length} = 0 or problem.difficulty = :#{#filters.difficulty})
      return *
        :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""", countQuery = """
      match (problem:Problem)
      optional match (problem)-[r_contest]-(contest:Contest)
      optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
      optional match (problem)-[r_user:LIKES]->(user:User)
      with problem as problem,
        contest as node_contest,
        category, r_category,
        user, r_user
      where (node_contest is null or node_contest.status='CLOSED')
        and (:#{#filters.id} = -1 or ID(problem) = :#{#filters.id})
        and (:#{#filters.name.length} = 0 or problem.name =~ :#{#filters.name})
        and (:#{#filters.categories.size} = 0 or category.name in :#{#filters.categories})
        and (:#{#filters.likedBy.length} = 0 or :#{#filters.likedBy} = user.userId)
        and (:#{#filters.difficulty.length} = 0 or :#{#filters.difficulty} = problem.difficulty)
      return count(*)""")
  Page<ProblemValue> findAll(ProblemFilter filters, Pageable pageable);

  @Query(value = """
    match (problem:Problem)
    optional match (problem)-[r_category:IN_CATEGORY]->(category:Category)
    optional match (problem)-[r_code:CODE]->(code:Code)
    optional match (problem)-[r_test_case:TEST_CASES]->(test_case:TestCase)
    optional match (problem)<-[r_user:LIKES]-(user:User)
    with problem,
      category, r_category,
      collect(r_code) as r_codes, collect(code) as codes,
      collect(r_test_case)[0..3] as r_test_cases, collect(test_case)[0..3] as testCases,
      collect(r_user) as r_users
    with problem,
      category, r_category,
      r_codes, codes,
      r_test_cases, testCases,
      count(r_users) as likes
    where ID(problem) = $id
    return *""")
  Optional<ProblemValue> findProblemById(Long id);

  @Override
  @Query("""
      match (problem:Problem)
      optional match (problem)<-[r_submission:FOR_PROBLEM]-(submission:Submission)
      optional match (problem)-[r_code:CODE]->(code:Code)
      optional match (problem)-[r_test_case:TEST_CASES]->(test_case)
      with problem, code, test_case, submission
      where ID(problem)=$id
      detach delete problem, code, test_case, submission""")
  void deleteById(@NonNull Long id);

  boolean existsByIdAndLikedBy_UserIdContains(Long id, String userId);
}
