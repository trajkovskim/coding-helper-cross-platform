package mk.com.codehelp.core.domain.repository.impl;

import java.util.List;
import java.util.Map;
import org.neo4j.driver.Record;
import org.neo4j.driver.Value;

import org.springframework.data.neo4j.core.Neo4jClient;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.enums.Difficulty;
import mk.com.codehelp.core.domain.model.Category;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.value.ProblemValue;
import mk.com.codehelp.core.domain.model.value.relations.ContestProblemValue;

@Repository
@RequiredArgsConstructor
public class ContestProblemRepository {

  private final Neo4jClient neo4jClient;

  private ContestProblemValue map(Record record) {

    ContestProblemValue contestProblemValue = new ContestProblemValue();
    contestProblemValue.setId(record.get("id").asLong());
    contestProblemValue.setScore(record.get("score").asInt());

    Value problem = record.get("problem");
    ProblemValue problemValue = new ProblemValue();
    problemValue.setId(problem.get("id").asLong());
    problemValue.setName(problem.get("name").asString());
    problemValue.setDescription(problem.get("description").asString());
    problemValue.setMarkdown(problem.get("markdown").asString());
    problemValue.setDifficulty(Difficulty.valueOf(problem.get("difficulty").asString()));
    problemValue.setLikes(problem.get("likes").asLong());

    Category category = new Category();
    Value categoryValue = problem.get("category");
    category.setId(categoryValue.get("id").asLong());
    category.setName(categoryValue.get("name").asString());
    category.setDescription(categoryValue.get("description").asString());
    problemValue.setCategory(category);


    List<Problem.TestCase> testCases = problem.get("testCases").asList(testCaseValue -> {

      Problem.TestCase testCase = new Problem.TestCase();
      testCase.setId(testCaseValue.get("id").asLong());
      testCase.setIn(testCaseValue.get("in").asString());
      testCase.setOut(testCaseValue.get("out").asString());

      return testCase;
    });
    problemValue.setTestCases(testCases);

    List<Problem.Code> codes = problem.get("codes").asList(codeValue -> {

      Problem.Code code = new Problem.Code();
      code.setId(codeValue.get("id").asLong());
      code.setLanguage(codeValue.get("language").asString());
      code.setRunner(codeValue.get("runner").asString());
      code.setStarter(codeValue.get("starter").asString());

      return code;
    });
    problemValue.setCodes(codes);

    contestProblemValue.setProblem(problemValue);

    return contestProblemValue;
  }

  public List<ContestProblemValue> getContestProblems(Long contestId) {

    return neo4jClient.query("""
      match (contest:Contest)-[r_problem:IN_CONTEST]-(problem:Problem)
      optional match (problem)-[r_category:IN_CATEGORY]-(category:Category)
      optional match (problem)-[r_code:CODE]-(code:Code)
      optional match (problem)-[r_test_cases:TEST_CASES]-(testCase:TestCase)
      optional match (problem)-[r_user:LIKES]-(user:User)
      where ID(contest) = $contestId
      with category, code{.*, id: ID(code)}, testCase{.*, id: ID(testCase)}, count(user) as likes, problem, r_problem
      with category,
        collect(code) as codes,
        collect(testCase)[0..3] as testCases,
        likes,
        problem, r_problem
      return ID(r_problem) as id, problem{.*, id: ID(problem), category: category{.*, id: ID(category)}, codes: codes, testCases: testCases, likes: likes } as problem,
      r_problem.score as score;
      """)
      .bindAll(Map.of("contestId", contestId))
      .fetchAs(ContestProblemValue.class)
      .mappedBy((typeSystem, record) -> map(record))
      .all()
      .stream()
      .toList();
  }
}
