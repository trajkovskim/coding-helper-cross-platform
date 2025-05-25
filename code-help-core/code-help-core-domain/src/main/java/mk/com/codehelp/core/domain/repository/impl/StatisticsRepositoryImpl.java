package mk.com.codehelp.core.domain.repository.impl;

import java.util.List;
import java.util.Map;
import org.neo4j.driver.Record;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.core.Neo4jClient;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.model.value.SubmissionByCategoryCountPairsValue;
import mk.com.codehelp.core.domain.model.value.SubmissionByLanguageCountPairsValue;
import mk.com.codehelp.core.domain.model.value.UserRankingValue;
import mk.com.codehelp.core.domain.repository.StatisticsRepository;

@Repository
@RequiredArgsConstructor
public class StatisticsRepositoryImpl implements StatisticsRepository {

  private final Neo4jClient neo4jClient;

  public List<SubmissionByCategoryCountPairsValue> getCountsByCategoryPairs(String username, SubmissionStatus status) {

    return neo4jClient.query("""
      match (user:User)-[r_user:BY]-(submission:Submission)-[r_problem:FOR_PROBLEM]-(problem)
      where user.username = $username and submission.status = $status
      with distinct submission.status as status, problem
      match (problem:Problem)-[r_category:IN_CATEGORY]-(category:Category)
      with status, problem, category
      return category.name as category, count(problem) as count
      """)
      .bindAll(Map.of("username", username, "status", status.toString()))
      .fetchAs(SubmissionByCategoryCountPairsValue.class)
      .mappedBy((typeSystem, record) ->
        new SubmissionByCategoryCountPairsValue(
          record.get("category").asString(),
          record.get("count").asLong()))
      .all().stream().toList();
  }

  public List<SubmissionByLanguageCountPairsValue> getCountsByLanguagePairs(String username, SubmissionStatus status) {

    return neo4jClient.query("""
      match (user:User)-[r_user:BY]-(submission:Submission)
      match (submission:Submission)-[r_problem:FOR_PROBLEM]-(problem:Problem)
      with submission, problem, r_problem, user, r_user
      where user.username = $username and submission.status = $status
      with distinct submission.status as status, submission.language as language, ID(problem) as problemId
      return distinct status, language, count(status) as count
      """)
      .bindAll(Map.of("username", username, "status", status.toString()))
      .fetchAs(SubmissionByLanguageCountPairsValue.class)
      .mappedBy((typeSystem, record) ->
        new SubmissionByLanguageCountPairsValue(
          record.get("language").asString(),
          record.get("count").asLong()))
      .all().stream().toList();
  }

  private UserRankingValue map(Record record) {

    User user = new User();
    user.setUserId(record.get("user").get("userId").asString());
    user.setUsername(record.get("user").get("username").asString());

    return new UserRankingValue(
      user,
      record.get("score").asLong());
  }

  @Override
  public Page<UserRankingValue> getUserRankings(Pageable pageable) {

    Integer countTotal = neo4jClient.query("""
        match (user:User)
        optional match (submission:Submission)-[r_user:BY]-(user)
        optional match (submission)-[r_submission:FOR_PROBLEM]-(problem:Problem)
        optional match (problem)-[r_contest_problem:IN_CONTEST]-(contest:Contest)
        with distinct user, max(submission.testCasesPassed) as testCasesPassed, submission.testCasesCount as testCasesCount, problem
        return count(user) as count;
        """).fetchAs(Integer.class)
      .mappedBy((typeSystem, record) -> record.get("count").asInt())
      .one().orElse(0);

    List<UserRankingValue> content = neo4jClient.query("""
        match (user:User)
        optional match (submission:Submission)-[r_user:BY]-(user)
        optional match (submission)-[r_submission:FOR_PROBLEM]-(problem:Problem)
        optional match (problem)-[r_contest_problem:IN_CONTEST]-(contest:Contest)
        with distinct user, max(submission.testCasesPassed) as testCasesPassed, submission.testCasesCount as testCasesCount, problem, r_contest_problem
        with user, (testCasesPassed / testCasesCount) * r_contest_problem.score as score
        with user, sum(score) as score
        return * order by score desc SKIP $skip LIMIT $limit;
        """)
      .bindAll(Map.of(
        "skip", pageable.getOffset(),
        "limit", pageable.getPageSize()))
      .fetchAs(UserRankingValue.class)
      .mappedBy((typeSystem, record) -> map(record))
      .all().stream().toList();

    return new PageImpl<>(content, pageable, countTotal);
  }
}
