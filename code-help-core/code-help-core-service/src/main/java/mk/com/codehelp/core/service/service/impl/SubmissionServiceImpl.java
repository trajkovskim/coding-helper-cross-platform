package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.domain.dto.SubmissionDto;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.Submission;
import mk.com.codehelp.core.domain.repository.SubmissionRepository;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.service.SubmissionService;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SubmissionServiceImpl implements SubmissionService {
  private final SubmissionRepository submissionRepository;
  private final CodeRunnerService codeRunnerService;
  private final ProblemService problemService;

  @Override
  public List<SubmissionDto> findAllSubmissionsByEmail(String email) {
    return submissionRepository.findAllByUser(email);
  }

  @Override
  public List<SubmissionDto> findAllSubmissionsByUserEmailAndProblemId(String email, Long problemId) {
    return submissionRepository.findAllByUserAndProblem_Id(email, problemId);
  }

  @Override
  public String create(String email, Long problemId, String code, String language) throws IOException, InterruptedException {
    String user = SecurityContextHolder.getContext().getAuthentication().getName();
    Problem problem = problemService.findById(problemId);

    String output = codeRunnerService.runCodeWithTestCases(problemId, language, code);

    this.submissionRepository.save(
        new Submission(
            new Date(),
            output != null && output.startsWith("All") ? SubmissionStatus.ACCEPTED : SubmissionStatus.DECLINED,
            language,
            code,
            user,
            problem
        )
    );
    return output;
  }


}
