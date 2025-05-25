package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Submission;
import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface SubmissionRepository extends Neo4jRepository<Submission, Long> {

  @Query(value = """
    match (user:User)-[r_user:BY]-(submission:Submission)
    where user.userId = :#{#filters.userId}
      and (:#{#filters.status.length} = 0 or submission.status = :#{#filters.status})
    return submission :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""",
  countQuery = """
    match (user:User)-[r_user:BY]-(submission:Submission)
    where user.userId = :#{#filters.userId}
      and (:#{#filters.status.length} = 0 or submission.status = :#{#filters.status})
    return count(submission)""")
  Page<SubmissionValue> findAll(SubmissionFilter filters, Pageable pageable);

  @Query(value = """
    match (user:User)-[r_user:BY]-(submission:Submission)-[r_problem:FOR_PROBLEM]-(problem:Problem)
    where ID(problem) = $problemId
      and user.userId = :#{#filters.userId}
      and (:#{#filters.status.length} = 0 or submission.status = :#{#filters.status})
    return submission :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""",
    countQuery = """
    match (user:User)-[r_user:BY]-(submission:Submission)-[r_problem:FOR_PROBLEM]-(problem:Problem)
    where ID(problem) = $problemId
      and user.userId = :#{#filters.userId}
      and (:#{#filters.status.length} = 0 or submission.status = :#{#filters.status})
    return count(submission)""")
  Page<SubmissionValue> findAllByProblem(SubmissionFilter filters, Long problemId, Pageable pageable);

  Long countDistinctByStatusAndProblem_DifficultyAndUser_Username(SubmissionStatus status, Difficulty problem_difficulty, String username);
}
