package mk.com.codehelp.core.api.controller.admin;

import java.util.List;

import mk.com.codehelp.core.api.factory.AdminLinksFactory;
import mk.com.codehelp.core.api.mappers.admin.AdminContestMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.admin.api.ContestApi;
import mk.com.codehelp.core.rest.admin.model.*;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.service.ContestService;
import mk.com.codehelp.core.service.util.PageUtil;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
public class ContestAdminController implements ContestApi {

    private final ContestService contestService;
    private final AdminContestMapper contestMapper;
    private final AdminLinksFactory linksFactory;

    public ContestAdminController(
        @Qualifier("contestAdminService") ContestService contestService,
        AdminContestMapper contestMapper,
        AdminLinksFactory linksFactory) {

        this.contestService = contestService;
        this.contestMapper = contestMapper;
        this.linksFactory = linksFactory;
    }

    @Override
    public ResponseEntity<ContestsResponse> getAllContests(Integer page, Integer size, List<String> sortBy) {

        Pageable pageRequest = PageUtil.createPageRequest(page, size, sortBy);

        PageInfoDto<Contest> contestPage = contestService.findAll(pageRequest);

        PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
            contestPage,
            (pageNumber, pageSize) ->
                methodOn(ContestAdminController.class).getAllContests(pageNumber, pageSize, sortBy));

        List<mk.com.codehelp.core.rest.admin.model.Contest> contests = contestMapper.convert(contestPage.getItems());

        ContestsResponse contestsResponse = new ContestsResponse()
            .contests(contests)
            .pageNumber(page)
            .pageSize(size)
            .totalElements(contestPage.getTotalElements())
            .totalPages(contestPage.getTotalPages())
            .links(paginationLinks);

        return ResponseEntity.ok(contestsResponse);
    }

    @Override
    public ResponseEntity<ContestDetail> getContest(Long id) {

        ContestDetail contestDetail = contestMapper.convert(contestService.findById(id));

        return ResponseEntity.ok(contestDetail);
    }

    @Override
    public ResponseEntity<CreatedResponse> createContest(ContestRequest contestRequest) {

        Contest convert = contestMapper.convert(contestRequest);

        Contest created = contestService.createContest(convert);

        SelfLink selfLink = linksFactory.createSelfLink(methodOn(ContestAdminController.class)
            .getContest(created.getId()));

        CreatedResponse createdResponse = new CreatedResponse().links(selfLink);

        return ResponseEntity.status(HttpStatus.CREATED).body(createdResponse);
    }

    @Override
    public ResponseEntity<Void> updateContest(Long id, ContestEditRequest contestEditRequest) {

        Contest convert = contestMapper.convert(id, contestEditRequest);

        contestService.update(id, convert);

        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<Void> deleteContest(Long id) {

        contestService.deleteById(id);

        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<Void> startContest(Long id) {

        contestService.startContest(id);

        return ResponseEntity.noContent().build();
    }

    @Override
    public ResponseEntity<Void> closeContest(Long id) {

        contestService.closeContest(id);

        return ResponseEntity.noContent().build();
    }
}
