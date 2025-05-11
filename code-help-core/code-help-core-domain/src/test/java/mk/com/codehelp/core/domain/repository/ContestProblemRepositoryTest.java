package mk.com.codehelp.core.domain.repository;

import java.util.List;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.relations.ContestProblem;
import mk.com.codehelp.core.domain.model.value.relations.ContestProblemValue;
import mk.com.codehelp.core.domain.repository.impl.ContestProblemRepository;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
public class ContestProblemRepositoryTest {

  @Autowired
  private ContestProblemRepository repository;

  @Autowired
  private ContestRepository contestRepository;

  private Contest createContest() {

    Contest contest = new Contest();
    contest.setName("test");

    Problem problem = new Problem();
    problem.setName("problem");
    problem.setDescription("test");
    problem.setDifficulty(Difficulty.MEDIUM);

    Category category = new Category();
    category.setName("category");
    problem.setCategory(category);

    Problem.TestCase testCase1 = new Problem.TestCase();
    testCase1.setIn("in");
    testCase1.setOut("out");

    Problem.TestCase testCase2 = new Problem.TestCase();
    testCase2.setIn("in");
    testCase2.setOut("out");

    problem.setTestCases(List.of(testCase1, testCase2));

    Problem.Code code = new Problem.Code();
    code.setLanguage("java");
    problem.setCodes(List.of(code));

    ContestProblem contestProblem = new ContestProblem(problem, 100);
    contest.setProblems(List.of(contestProblem));

    return contest;
  }

  @Test
  void shouldGetContestProblems() {

    // Given
    Contest contest = createContest();
    contestRepository.save(contest);

    // When
    List<ContestProblemValue> contestProblems = repository.getContestProblems(contest.getId());

    // Then
    System.out.println(contestProblems);
  }
}
