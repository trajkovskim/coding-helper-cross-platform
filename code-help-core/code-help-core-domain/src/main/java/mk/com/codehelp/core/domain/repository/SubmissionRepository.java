package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Submission;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubmissionRepository extends Neo4jRepository<Submission, Long> {

  List<SubmissionValue> findAllByUser(String Email);

  Long countDistinctByStatusAndProblem_DifficultyAndUser(SubmissionStatus status, Difficulty problem_difficulty, String user);

  List<SubmissionValue> findAllByUserAndProblem_Id(String user_email, Long problem_id);


}
