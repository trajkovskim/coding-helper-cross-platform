package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import mk.com.codehelp.core.api.factory.AdminLinksFactory;
import mk.com.codehelp.core.api.mappers.admin.AdminProblemMapper;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.rest.admin.api.ProblemApi;
import mk.com.codehelp.core.rest.admin.model.CreatedResponse;
import mk.com.codehelp.core.rest.admin.model.PaginationLinks;
import mk.com.codehelp.core.rest.admin.model.ProblemDetail;
import mk.com.codehelp.core.rest.admin.model.ProblemRequest;
import mk.com.codehelp.core.rest.admin.model.ProblemsResponse;
import mk.com.codehelp.core.rest.admin.model.SelfLink;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.ProblemDto;
import mk.com.codehelp.core.service.dto.ProblemEmbeddedDto;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.service.ProblemService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class ProblemAdminController implements ProblemApi {

    private final ProblemService problemService;

    private final ContestService contestService;
    private final AdminProblemMapper problemMapper;
    private final AdminLinksFactory linksFactory;

    @Override
    @SneakyThrows
    public ResponseEntity<CreatedResponse> createProblem(Long contestId, Integer score, ProblemRequest problemRequest) {

        Problem problem = problemMapper.convert(problemRequest);

        Long createdId;
        if (contestId == null) {
            Problem created = problemService.create(problem);
            createdId = created.getId();
        } else {
            ContestProblem created = contestService.addProblemToContest(contestId, score, problem);
            createdId = created.getId();
        }

        SelfLink selfLink = linksFactory.createSelfLink(methodOn(ProblemAdminController.class)
            .getProblem(createdId));

        CreatedResponse createdResponse = new CreatedResponse().links(selfLink);

        return ResponseEntity.status(HttpStatus.CREATED).body(createdResponse);
    }

    @Override
    public ResponseEntity<ProblemsResponse> getAllProblems(Integer page, Integer size, List<String> sortBy, String name) {

        Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);

        ProblemFilter problemFilter = new ProblemFilter();
        problemFilter.setName(name);

        PageInfoDto<ProblemDto> problemsPage = problemService.findAll(problemFilter, pageRequest);

        PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
            problemsPage,
            (pageNumber, pageSize) ->
                methodOn(ProblemAdminController.class).getAllProblems(pageNumber, pageSize, sortBy, name));

        List<mk.com.codehelp.core.rest.admin.model.Problem> problems = problemMapper.convert(problemsPage.getItems());

        ProblemsResponse response = new ProblemsResponse()
            .problems(problems)
            .totalElements(problemsPage.getTotalElements())
            .totalPages(problemsPage.getTotalPages())
            .pageNumber(page)
            .pageSize(size)
            .links(paginationLinks);

        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<ProblemDetail> getProblem(Long id) {

        ProblemDetail problemDetail = problemMapper.convert(problemService.findById(id));

        return ResponseEntity.ok(problemDetail);
    }

    @SneakyThrows
    @Override
    public ResponseEntity<ProblemDetail> updateProblem(Long id, ProblemRequest problemRequest) {

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
