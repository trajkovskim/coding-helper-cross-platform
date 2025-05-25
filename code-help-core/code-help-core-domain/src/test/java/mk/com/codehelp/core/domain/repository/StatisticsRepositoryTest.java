package mk.com.codehelp.core.domain.repository;

import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.core.Neo4jTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.*;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.value.SubmissionByCategoryCountPairsValue;
import mk.com.codehelp.core.domain.model.value.SubmissionByLanguageCountPairsValue;
import mk.com.codehelp.core.domain.model.value.UserRankingValue;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
@WithMockUser
public class StatisticsRepositoryTest {

  @Autowired
  private StatisticsRepository statisticsRepository;

  @Autowired
  private SubmissionRepository submissionRepository;

  @Autowired
  private ContestRepository contestRepository;

  @Autowired
  private ProblemRepository problemRepository;

  @Autowired
  private UserRepository userRepository;

  @BeforeEach
  public void setUp() {

    User user = new User();

    String currentUser = SecurityContextHolder.getContext().getAuthentication().getName();
    user.setUserId(currentUser);
    user.setUsername("username");

    userRepository.save(user);
  }


  private Submission createSubmission(Problem problem) {
    return createSubmission(problem, 1);
  }

  private Submission createSubmission(Problem problem, Integer testCasesPassed) {
    return new Submission(SubmissionStatus.ACCEPTED, "javascript", "code", problem, testCasesPassed, problem.getTestCases().size());
  }

  private Category createCategory(String name) {

    Category category = new Category();
    category.setName(name);

    return category;
  }

  private Problem createProblem(Category category) {

    Problem problem = new Problem();
    problem.setCategory(category);

    Problem.TestCase testCase = new Problem.TestCase();
    testCase.setIn("in");
    testCase.setOut("out");
    problem.setTestCases(List.of(testCase));

    return problem;
  }

  @Test
  void shouldCountByCategorySolved() {

    // Given
    Category category1 = createCategory("category1");
    Problem problem1 = createProblem(category1);
    Submission submission1 = createSubmission(problem1);
    submissionRepository.save(submission1);

    Submission submission11 = createSubmission(problem1);
    submissionRepository.save(submission11);

    Submission submission12 = createSubmission(problem1);
    submission12.setStatus(SubmissionStatus.DECLINED);
    submissionRepository.save(submission12);

    Problem problem2 = createProblem(category1);
    Submission submission2 = createSubmission(problem2);
    submissionRepository.save(submission2);

    Category category2 = createCategory("category2");
    Problem problem3 = createProblem(category2);
    Submission submission3 = createSubmission(problem3);
    submissionRepository.save(submission3);


    // When
    List<SubmissionByCategoryCountPairsValue> counts = statisticsRepository.getCountsByCategoryPairs("user", SubmissionStatus.ACCEPTED);

    // Then
    assertEquals(2, counts.get(0).getCount());
    assertEquals(1, counts.get(1).getCount());
  }

  @Test
  void shouldCountLanguageSolved() {

    // Given
    Category category1 = createCategory("category1");
    Problem problem1 = createProblem(category1);
    Submission submission1 = createSubmission(problem1);
    submissionRepository.save(submission1);

    Submission submission2 = createSubmission(problem1);
    submissionRepository.save(submission2);

    Submission submission3 = createSubmission(problem1);
    submission3.setStatus(SubmissionStatus.DECLINED);
    submissionRepository.save(submission3);

    Submission submission4 = createSubmission(problem1);
    submission4.setLanguage("java");
    submissionRepository.save(submission4);

    Submission submission5 = createSubmission(problem1);
    submission5.setLanguage("java");
    submissionRepository.save(submission5);

    Submission submission6 = createSubmission(problem1);
    submission6.setLanguage("c++");
    submissionRepository.save(submission6);

    // When
    List<SubmissionByLanguageCountPairsValue> languageCountPairs = statisticsRepository.getCountsByLanguagePairs("user", SubmissionStatus.ACCEPTED);

    // Then
    assertEquals(2, languageCountPairs.get(0).getCount());
    assertEquals(2, languageCountPairs.get(1).getCount());
    assertEquals(1, languageCountPairs.get(2).getCount());
  }

  @Test
  void shouldGetUserRankings() {

    // Given
    List<User> all = userRepository.findAll();
    int usersSizeBefore = all.size();

    Category category1 = createCategory("category1");
    Problem problem1 = createProblem(category1);
    problemRepository.save(problem1);

    Submission submission1 = createSubmission(problem1);
    submissionRepository.save(submission1);

    Submission submission2 = createSubmission(problem1);
    submissionRepository.save(submission2);

    ContestProblem contestProblem = new ContestProblem(problem1, 50);

    Contest contest = new Contest();
    contest.setProblems(List.of(contestProblem));
    contestRepository.save(contest);

    String currentUser = SecurityContextHolder.getContext().getAuthentication().getName();

    Pageable pageable = PageRequest.of(0, 10);
    // When
    Page<UserRankingValue> userRankings = statisticsRepository.getUserRankings(pageable);

    UserRankingValue ranking = userRankings.getContent()
      .stream()
      .filter(x -> currentUser.equals(x.getUser().getUserId()))
      .findAny()
      .orElse(null);

    // Then
    assertEquals(usersSizeBefore, userRankings.getTotalElements());
    assertEquals(50, ranking.getScore());
    assertEquals(currentUser, ranking.getUser().getUserId());
  }

  @Test
  void shouldGetUserRankingsWhenNoSubmissions() {

    // Given
    List<User> all = userRepository.findAll();
    int usersSizeBefore = all.size();

    String currentUser = UUID.randomUUID().toString();

    User user = new User();
    user.setUserId(currentUser);
    userRepository.save(user);

    Pageable pageable = PageRequest.of(0, 10);
    // When
    Page<UserRankingValue> userRankings = statisticsRepository.getUserRankings(pageable);

    // Then

    UserRankingValue ranking = userRankings.getContent()
      .stream()
      .filter(x -> currentUser.equals(x.getUser().getUserId()))
      .findAny()
      .orElse(null);

    assertEquals(usersSizeBefore + 1, userRankings.getTotalElements());
    assertEquals(0, ranking.getScore());
    assertEquals(currentUser, ranking.getUser().getUserId());
  }
}
