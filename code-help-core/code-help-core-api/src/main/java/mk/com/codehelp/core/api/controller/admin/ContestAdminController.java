package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.admin.AdminContestMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.admin.api.ContestApi;
import mk.com.codehelp.core.rest.admin.model.ContestDetail;
import mk.com.codehelp.core.rest.admin.model.ContestEditRequest;
import mk.com.codehelp.core.rest.admin.model.ContestRequest;
import mk.com.codehelp.core.rest.admin.model.ContestResponse;
import mk.com.codehelp.core.service.service.ContestService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ContestAdminController implements ContestApi {

    private final ContestService contestService;
    private final AdminContestMapper contestMapper;

    @Override
    public ResponseEntity<ContestResponse> getAllContests() {

        List<Contest> contests = contestService.findAll();

        ContestResponse contestResponse = contestMapper.convert(contests);

        return ResponseEntity.ok(contestResponse);
    }

    @Override
    public ResponseEntity<ContestDetail> getContest(Long id) {

        ContestDetail contestDetail = contestMapper.convert(contestService.findById(id));

        return ResponseEntity.ok(contestDetail);
    }

    @Override
    public ResponseEntity<Void> createContest(ContestRequest contestRequest) {

        Contest convert = contestMapper.convert(contestRequest);

        contestService.createContest(convert);

        return ResponseEntity.status(HttpStatus.CREATED).build();
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
