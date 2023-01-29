package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.dto.SubmissionDto;

import java.io.IOException;
import java.util.List;

public interface SubmissionService {
  List<SubmissionDto> findAllSubmissionsByEmail(String email);

  List<SubmissionDto> findAllSubmissionsByUserEmailAndProblemId(String email, Long problemId);

  String create(String email, Long problemId, String code, String language) throws IOException, InterruptedException;

}
