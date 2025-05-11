package mk.com.codehelp.core.domain.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

import mk.com.codehelp.core.domain.enums.ContestStatus;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.value.ContestValue;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
public class ContestRepositoryTest {

  @Autowired
  private ContestRepository contestRepository;

  private Contest createContest() {

    User user = new User("test");

    Contest contest = new Contest();
    contest.setName("title");
    contest.setDescription("description");
    contest.setStatus(ContestStatus.OPEN);
    contest.setDuration("1h30m");
    contest.setStartDate(LocalDateTime.now());

    Problem problem = new Problem();
    problem.setName("problem");
    problem.setDescription("description");
    problem.setLikedBy(List.of(user));

    Category category = new Category();
    category.setName("category");
    problem.setCategory(category);

    Problem.Code code = new Problem.Code();
    code.setLanguage("java");
    problem.setCodes(List.of(code));

    Problem.TestCase testCase = new Problem.TestCase();
    testCase.setIn("in");
    testCase.setOut("out");
    problem.setTestCases(List.of(testCase));

    ContestProblem contestProblem = new ContestProblem(problem, 12);
    contest.setProblems(List.of(contestProblem));

    contest.setParticipants(List.of(user));

    return contest;
  }

  private static Stream<Arguments> shouldGetContestsArguments() {

    ContestFilter titleFilter = new ContestFilter();
    titleFilter.setName("title1");

    ContestFilter statusFilter = new ContestFilter();
    statusFilter.setStatus(ContestStatus.STARTED);

    ContestFilter emptyFilter = new ContestFilter();

    Pageable pageRequest = PageRequest.of(0, 10);

    return Stream.of(
      Arguments.arguments(titleFilter, pageRequest, 1),
      Arguments.arguments(statusFilter, pageRequest, 1),
      Arguments.arguments(emptyFilter, pageRequest, 2)
    );
  }

  @ParameterizedTest
  @MethodSource("shouldGetContestsArguments")
  void shouldGetContests(ContestFilter filter, Pageable pageable, int expectedTotal) {

    // Given
    long totalElementsBefore = contestRepository.findAll(filter, pageable).getTotalElements();

    Contest contest1 = createContest();
    contest1.setName("title123");
    contestRepository.save(contest1);

    Contest contest2 = createContest();
    contest2.setStatus(ContestStatus.STARTED);
    contestRepository.save(contest2);

    // When
    Page<ContestValue> contestsPage = contestRepository.findAll(filter, pageable);

    // Then
    assertEquals(expectedTotal + totalElementsBefore, contestsPage.getTotalElements());
  }

  @Test
  void shouldGetContestById() {

    // Given
    Contest contest = createContest();
    contestRepository.save(contest);

    // When
    Optional<Contest> found = contestRepository.findById(contest.getId());

    // Then
    assertTrue(found.isPresent());
    assertEquals(contest.getId(), found.get().getId());
    assertEquals(1, contest.getParticipants().size());
    assertEquals(contest.getParticipants().get(0).getUsername(), found.get().getParticipants().get(0).getUsername());
  }

  @Test
  void shouldGetContestProjectionById() {

    // Given
    Contest contest = createContest();
    contestRepository.save(contest);

    // When
    Optional<ContestValue> found = contestRepository.findContestById(contest.getId());

    // Then
    assertTrue(found.isPresent());
    assertEquals(contest.getId(), found.get().getId());
    assertEquals(contest.getParticipants().size(), found.get().getParticipantsSize());
  }
}
