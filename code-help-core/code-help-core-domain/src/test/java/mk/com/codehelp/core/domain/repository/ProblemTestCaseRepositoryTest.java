package mk.com.codehelp.core.domain.repository;

import java.util.List;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;

import static org.junit.jupiter.api.Assertions.assertEquals;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
public class ProblemTestCaseRepositoryTest {

  @Autowired
  private ProblemTestCaseRepository problemTestCaseRepository;

  @Autowired
  private ProblemRepository problemRepository;

  @Autowired
  private CategoryRepository categoryRepository;

  private Category saveCategory(String name) {

    Category category = new Category();
    category.setName(name);

    return categoryRepository.save(category);
  }

  private Problem createProblem(Category category) {

    Problem problem = new Problem();
    problem.setName("title");
    problem.setCategory(category);
    problem.setDifficulty(Difficulty.EASY);
    problem.setMarkdown("MARKDOWN");

    Problem.Code code = new Problem.Code();
    code.setStarter("starter");
    code.setRunner("runner");
    code.setLanguage("javascript");
    problem.setCodes(List.of(code));

    return problem;
  }

  @Test
  void shouldFindAllProblemTestCases() {

    // Given
    Category category = saveCategory("test");

    Problem problem = createProblem(category);

    Problem.TestCase testCase1 = new Problem.TestCase();
    testCase1.setIn("0, 1, 2");
    testCase1.setOut("0, 1, 2");

    Problem.TestCase testCase2 = new Problem.TestCase();
    testCase2.setIn("0, 1, 2");
    testCase2.setOut("0, 1, 2");

    problem.setTestCases(List.of(testCase1, testCase2));

    problemRepository.save(problem);

    PageRequest pageRequest = PageRequest.of(0, 10);

    // When
    Page<Problem.TestCase> testCasesPage = problemTestCaseRepository.findAllByProblem(problem.getId(), pageRequest);

    // Then
    assertEquals(2, testCasesPage.getTotalElements());
  }
}
