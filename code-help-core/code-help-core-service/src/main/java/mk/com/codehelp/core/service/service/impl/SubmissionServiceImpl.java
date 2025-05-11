package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;
import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.Submission;
import mk.com.codehelp.core.domain.repository.SubmissionRepository;
import mk.com.codehelp.core.service.dto.CodeRunnerDto;
import mk.com.codehelp.core.service.dto.CreatedSubmissionDto;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.service.CodeRunnerService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.service.SubmissionService;
import mk.com.codehelp.core.service.util.CodeUtil;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubmissionServiceImpl implements SubmissionService {

  private final SubmissionRepository submissionRepository;
  private final CodeRunnerService codeRunnerService;
  private final ProblemService problemService;
  private final CodeUtil codeUtil;

  @Override
  public PageInfoDto<SubmissionValue> findAll(SubmissionFilter submissionFilter, Pageable pageable) {

    Page<SubmissionValue> submissionValuePage = submissionRepository.findAll(submissionFilter, pageable);

    return PageUtil.createPageInfo(submissionValuePage, pageable);
  }

  @Override
  public CreatedSubmissionDto create(String email, Long problemId, String code, String language)
    throws IOException, InterruptedException {

    Problem problem = problemService.findById(problemId);
    ProblemDto problemDto = problemService.getProblem(problemId, language);
    String mergedCode = codeUtil.mergeCode(code, problemDto.getCode().getRunner());
    CodeRunnerDto codeRunnerDto = codeRunnerService.runTestCases(problem.getTestCases(), mergedCode, language);

    Submission saved = this.submissionRepository.save(
      new Submission(
        codeRunnerDto.isError() ? SubmissionStatus.ACCEPTED : SubmissionStatus.DECLINED,
        language,
        code,
        problem,
        codeRunnerDto.getTestCasesPassed(),
        problem.getTestCases().size()
      )
    );

    return CreatedSubmissionDto.builder()
        .status(saved.getStatus())
        .message(codeRunnerDto.getMessage())
        .build();
  }


}
