package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.dto.SubmissionDto;
import mk.com.codehelp.core.domain.model.Submission;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubmissionRepository extends Neo4jRepository<Submission, Long> {

    List<SubmissionDto> findAllByUser_Email(String Email);

    List<SubmissionDto> findAllByUser_EmailAndProblem_Id(String user_email, Long problem_id);


}
