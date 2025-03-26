package mk.com.codehelp.core.domain.repository;

import java.util.List;
import java.util.stream.Stream;
import org.junit.jupiter.api.Disabled;
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
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;
import mk.com.codehelp.core.domain.model.value.ProblemValue;

import static org.junit.jupiter.api.Assertions.*;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
@Disabled
public class ProblemRepositoryTest {

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
    problem.setTitle("title");
    problem.setCategory(category);
    problem.setDifficulty(Difficulty.EASY);
    problem.setMarkdown("MARKDOWN");

    Problem.Code starterCode = new Problem.Code();
    starterCode.setCode("starter");
    starterCode.setLanguage("javascript");
    problem.setStarterCode(List.of(starterCode));

    Problem.Code runnerCode = new Problem.Code();
    runnerCode.setCode("runner");
    runnerCode.setLanguage("javascript");
    problem.setRunnerCode(List.of(runnerCode));

    return problem;
  }

  private static Stream<Arguments> shouldGetProblemsArguments() {

    ProblemFilter categoriesFilter = new ProblemFilter();
    categoriesFilter.setCategories(List.of("test"));

    ProblemFilter likedByFilter = new ProblemFilter();
    likedByFilter.setLikedBy("test");

    ProblemFilter categoriesAndLikedByFilter = new ProblemFilter();
    categoriesAndLikedByFilter.setLikedBy("test");
    categoriesAndLikedByFilter.setCategories(List.of("test"));

    ProblemFilter emptyFilter = new ProblemFilter();

    Pageable pageRequest = PageRequest.of(0, 10);

    return Stream.of(
        Arguments.arguments(categoriesFilter, pageRequest, 2),
        Arguments.arguments(likedByFilter, pageRequest, 1),
        Arguments.arguments(categoriesAndLikedByFilter, pageRequest, 1),
        Arguments.arguments(emptyFilter, pageRequest, 2)
    );
  }

  @ParameterizedTest
  @MethodSource("shouldGetProblemsArguments")
  void shouldGetProblems(ProblemFilter filter, Pageable pageable, int expectedTotal) {

    // Given
    Category category = saveCategory("test");

    long totalElementsBefore = problemRepository.findAll(filter, pageable).getTotalElements();

    Problem problem1 = createProblem(category);
    problemRepository.save(problem1);

    Problem problem2 = createProblem(category);
    problem2.setLikedBy(List.of("test"));
    problemRepository.save(problem2);

    // When
    Page<ProblemValue> problemValuePage = problemRepository.findAll(filter, pageable);

    // Then
    assertEquals(expectedTotal + totalElementsBefore, problemValuePage.getTotalElements());
  }

  @Test
  void shouldCreateProblem() {

    Category category = new Category();
    category.setName("test");
    categoryRepository.save(category);

    Problem problem = new Problem();
    problem.setTitle("title");
    problem.setCategory(category);
    problem.setDifficulty(Difficulty.EASY);
    problem.setMarkdown("MARKDOWN");

    Problem.Code starterCode = new Problem.Code();
    starterCode.setCode("starter");
    starterCode.setLanguage("javascript");
    problem.setStarterCode(List.of(starterCode));

    Problem.Code runnerCode = new Problem.Code();
    runnerCode.setCode("runner");
    runnerCode.setLanguage("javascript");
    problem.setRunnerCode(List.of(runnerCode));

    Problem saved = problemRepository.save(problem);

    assertNotNull(saved.getId());
  }
}
