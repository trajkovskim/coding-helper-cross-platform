package mk.com.codehelp.core.domain.repository;

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

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.domain.model.value.ProblemValue;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
public class ProblemRepositoryTest {

  @Autowired
  private ProblemRepository problemRepository;

  @Autowired
  private CategoryRepository categoryRepository;

  private Category saveCategory(String name) {

    Category category = new Category();
    category.setName(name);
    category.setDescription("description");

    return categoryRepository.save(category);
  }

  private Problem createProblem(Category category) {

    Problem problem = new Problem();
    problem.setName("title");
    problem.setDescription("description");
    problem.setCategory(category);
    problem.setDifficulty(Difficulty.EASY);
    problem.setMarkdown("MARKDOWN");

    Problem.Code code = new Problem.Code();
    code.setStarter("starter");
    code.setRunner("runner");
    code.setLanguage("javascript");
    problem.setCodes(List.of(code));

    Problem.TestCase testCase = new Problem.TestCase();
    problem.setTestCases(List.of(testCase));

    User user = new User("user");
    problem.setLikedBy(List.of(user));

    return problem;
  }

  private static Stream<Arguments> shouldGetProblemsArguments() {

    ProblemFilter titleFilter = new ProblemFilter();
    titleFilter.setName("title1");

    ProblemFilter categoriesFilter = new ProblemFilter();
    categoriesFilter.setCategories(List.of("test"));

    ProblemFilter likedByFilter = new ProblemFilter();
    likedByFilter.setLikedBy("test");

    ProblemFilter difficultyFilter = new ProblemFilter();
    difficultyFilter.setDifficulty(Difficulty.HARD);

    ProblemFilter categoriesAndLikedByFilter = new ProblemFilter();
    categoriesAndLikedByFilter.setLikedBy("test");
    categoriesAndLikedByFilter.setCategories(List.of("test"));

    ProblemFilter emptyFilter = new ProblemFilter();

    Pageable pageRequest = PageRequest.of(0, 10);

    return Stream.of(
        Arguments.arguments(titleFilter, pageRequest, 1),
        Arguments.arguments(categoriesFilter, pageRequest, 3),
        Arguments.arguments(likedByFilter, pageRequest, 1),
        Arguments.arguments(difficultyFilter, pageRequest, 1),
        Arguments.arguments(categoriesAndLikedByFilter, pageRequest, 1),
        Arguments.arguments(emptyFilter, pageRequest, 3)
    );
  }

  @ParameterizedTest
  @MethodSource("shouldGetProblemsArguments")
  void shouldGetProblems(ProblemFilter filter, Pageable pageable, int expectedTotal) {

    // Given
    Category category = saveCategory("test");

    long totalElementsBefore = problemRepository.findAll(filter, pageable).getTotalElements();

    Problem problem1 = createProblem(category);
    problem1.setName("title123");
    problemRepository.save(problem1);

    Problem problem2 = createProblem(category);
    User user = new User("test");
    problem2.setLikedBy(List.of(user));
    problemRepository.save(problem2);

    Problem problem3 = createProblem(category);
    problem3.setDifficulty(Difficulty.HARD);
    problemRepository.save(problem3);

    // When
    Page<ProblemValue> problemValuePage = problemRepository.findAll(filter, pageable);

    // Then
    assertEquals(expectedTotal + totalElementsBefore, problemValuePage.getTotalElements());
    assertFalse(problemValuePage.getContent().get(0).getTestCases().isEmpty());
  }

  @Test
  void shouldFindProblemById() {

    // Given
    Category category = saveCategory("test");

    Problem problem = createProblem(category);
    problemRepository.save(problem);

    // When
    Optional<ProblemValue> problemById = problemRepository.findProblemById(problem.getId());

    // Then
    assertTrue(problemById.isPresent());
    assertEquals(problemById.get().getCategory().getName(), category.getName());
    assertEquals(problemById.get().getTestCases().size(), problem.getTestCases().size());
    assertEquals(problemById.get().getName(), problem.getName());
    assertEquals(problemById.get().getDescription(), problem.getDescription());
    assertEquals(problemById.get().getDifficulty(), problem.getDifficulty());
    assertEquals(problemById.get().getMarkdown(), problem.getMarkdown());
    assertEquals(problemById.get().getLikes(), problem.getLikedBy().size());
  }

  @Test
  void shouldCreateProblem() {

    Category category = new Category();
    category.setName("test");
    categoryRepository.save(category);

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

    Problem saved = problemRepository.save(problem);

    assertNotNull(saved.getId());
  }
}
