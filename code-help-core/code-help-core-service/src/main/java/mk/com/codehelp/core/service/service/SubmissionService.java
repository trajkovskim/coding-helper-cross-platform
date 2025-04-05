package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;

import java.io.IOException;
import java.util.List;

public interface SubmissionService {

  List<SubmissionValue> findAllSubmissionsByEmail(String email);

  List<SubmissionValue> findAllSubmissionsByUserEmailAndProblemId(String email, Long problemId);

  CreatedSubmissionDto create(String email, Long problemId, String code, String language) throws IOException, InterruptedException;
}
