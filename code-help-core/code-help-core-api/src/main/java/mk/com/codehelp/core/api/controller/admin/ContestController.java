package mk.com.codehelp.core.api.controller.admin;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.controller.CodingHelperController;
import mk.com.codehelp.core.api.mappers.admin.ContestMapper;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.rest.admin.api.AdminApi;
import mk.com.codehelp.core.rest.admin.model.ContestDetail;
import mk.com.codehelp.core.rest.admin.model.ContestEditRequest;
import mk.com.codehelp.core.rest.admin.model.ContestRequest;
import mk.com.codehelp.core.rest.admin.model.ContestResponse;
import mk.com.codehelp.core.service.service.ContestService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

@CodingHelperController
@RequiredArgsConstructor
public class ContestController implements AdminApi {

  private final ContestService contestService;
  private final ContestMapper contestMapper;

  @Override
  public ResponseEntity<ContestResponse> getAllContests(String authorization) {

    List<Contest> contests = contestService.findAll();

    ContestResponse contestResponse = contestMapper.convert(contests);

    return ResponseEntity.ok(contestResponse);
  }

  @Override
  public ResponseEntity<ContestDetail> getContest(Long id, String authorization) {

    ContestDetail contestDetail = contestMapper.convert(contestService.findById(id));

    return ResponseEntity.ok(contestDetail);
  }

  @Override
  public ResponseEntity<Void> createContest(String authorization, ContestRequest contestRequest) {

    Contest convert = contestMapper.convert(contestRequest);

    contestService.createContest(convert);

    return ResponseEntity.status(HttpStatus.CREATED).build();
  }

  @Override
  public ResponseEntity<Void> updateContest(Long id, String authorization, ContestEditRequest contestEditRequest) {

    Contest convert = contestMapper.convert(id, contestEditRequest);

    contestService.update(id, convert);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> deleteContest(Long id, String authorization) {

    contestService.deleteById(id);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> startContest(Long id, String authorization) {

    contestService.startContest(id);

    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<Void> closeContest(Long id, String authorization) {

    contestService.closeContest(id);

    return ResponseEntity.noContent().build();
  }
}
