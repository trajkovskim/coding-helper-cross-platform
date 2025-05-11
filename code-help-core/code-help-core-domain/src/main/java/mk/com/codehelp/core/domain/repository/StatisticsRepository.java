package mk.com.codehelp.core.domain.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.value.SubmissionByCategoryCountPairsValue;
import mk.com.codehelp.core.domain.model.value.SubmissionByLanguageCountPairsValue;
import mk.com.codehelp.core.domain.model.value.UserRankingValue;

public interface StatisticsRepository {

  List<SubmissionByCategoryCountPairsValue> getCountsByCategoryPairs(String username, SubmissionStatus status);

  List<SubmissionByLanguageCountPairsValue> getCountsByLanguagePairs(String username, SubmissionStatus status);

  Page<UserRankingValue> getUserRankings(Pageable pageable);
}
