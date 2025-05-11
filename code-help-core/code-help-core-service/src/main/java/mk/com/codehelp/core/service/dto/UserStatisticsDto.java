package mk.com.codehelp.core.service.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

import mk.com.codehelp.core.domain.model.value.SubmissionByCategoryCountPairsValue;
import mk.com.codehelp.core.domain.model.value.SubmissionByLanguageCountPairsValue;

@Getter
@Builder
public class UserStatisticsDto {

  private Long solved;
  private Long easy;
  private Long medium;
  private Long hard;

  private List<SubmissionByLanguageCountPairsValue> languageCounts;
  private List<SubmissionByCategoryCountPairsValue> categoryCounts;
}
