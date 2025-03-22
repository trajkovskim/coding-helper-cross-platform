package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import mk.com.codehelp.core.api.admin.rest.model.ProblemRequest;
import mk.com.codehelp.core.api.mappers.admin.AdminProblemMapper;
import mk.com.codehelp.core.domain.dto.ProblemByLikesDto;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.ProblemFilter;
import mk.com.codehelp.core.rest.admin.api.ProblemApi;
import mk.com.codehelp.core.rest.admin.model.*;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProblemAdminController implements ProblemApi {

    private final ProblemService problemService;

    private final ContestService contestService;
    private final AdminProblemMapper problemMapper;

    private ProblemRequest createProblemRequest(
            CategoryRequest category,
            String title,
            Difficulty difficulty,
            String markdown,
            MultipartFile starterCode,
            MultipartFile runnerCode,
            List<MultipartFile> testCases
    ) {
        return ProblemRequest.builder()
                .category(category)
                .title(title)
                .difficulty(difficulty)
                .markdown(markdown)
                .starterCode(starterCode.getResource())
                .runnerCode(runnerCode.getResource())
                .testCases(testCases.stream().map(MultipartFile::getResource).toList())
                .build();
    }

    @Override
    @SneakyThrows
    public ResponseEntity<String> createProblem(String title, Difficulty difficulty, String markdown, MultipartFile starterCode, MultipartFile runnerCode, List<MultipartFile> testCases, Long contestId, CategoryRequest category) {
        ProblemRequest problemRequest = createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);

        Problem problem = problemMapper.convert(problemRequest);

        if (contestId == null) {
            problemService.create(problem);
        } else {
            contestService.addProblemToContest(contestId, problem);
        }

        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<ProblemResponse> getAllProblems() {

        Page<ProblemByLikesDto> problemsPage = problemService.findAll(Pageable.unpaged(), new ProblemFilter());

        List<ProblemByLikesDto> problems = problemsPage.getContent();

        return ResponseEntity.ok(problemMapper.convert(problems));
    }

    @Override
    public ResponseEntity<ProblemDetail> getProblem(Long id) {

        ProblemDetail problemDetail = problemMapper.convert(problemService.findById(id));

        return ResponseEntity.ok(problemDetail);
    }

    @SneakyThrows
    @Override
    public ResponseEntity<ProblemDetail> updateProblem(Long id, String title, Difficulty difficulty, String markdown, MultipartFile starterCode, MultipartFile runnerCode, List<MultipartFile> testCases, CategoryRequest category) {
        ProblemRequest problemRequest = createProblemRequest(category, title, difficulty, markdown, starterCode, runnerCode, testCases);

        Problem problem = problemMapper.convert(id, problemRequest);

        Problem updated = problemService.update(id, problem);

        ProblemDetail problemDetail = problemMapper.convert(updated);

        return ResponseEntity.ok(problemDetail);
    }

    @Override
    public ResponseEntity<Void> deleteProblem(Long id) {

        problemService.deleteById(id);

        return ResponseEntity.noContent().build();
    }
}
