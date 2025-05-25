package mk.com.codehelp.core.domain.repository;

import java.util.stream.Stream;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

import mk.com.codehelp.core.domain.enums.SubmissionStatus;
import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.model.Submission;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.model.filter.SubmissionFilter;
import mk.com.codehelp.core.domain.model.value.SubmissionValue;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
@WithMockUser
public class SubmissionRepositoryTest {

  @Autowired
  private SubmissionRepository submissionRepository;

  @Autowired
  private UserRepository userRepository;

  private Submission createSubmission() {
    return new Submission(SubmissionStatus.ACCEPTED, "javascript", "code", new Problem(), 0, 0);
  }

  @BeforeEach
  public void setUp() {

    User user = new User();

    String currentUser = SecurityContextHolder.getContext().getAuthentication().getName();
    user.setUserId(currentUser);
    user.setUsername("username");

    userRepository.save(user);
  }

  @Test
  void shouldCreateSubmission() {

    // Given
    Submission submission = createSubmission();

    // When
    Submission saved = submissionRepository.save(submission);

    // Then
    assertNotNull(saved.getId());
    assertNotNull(saved.getCreatedDate());
    assertEquals("user", saved.getUser().getUserId());
    assertEquals(SubmissionStatus.ACCEPTED, saved.getStatus());
  }

  private static Stream<Arguments> shouldGetSubmissionsArguments() {

    SubmissionFilter userFilter = new SubmissionFilter();
    userFilter.setUserId("user");

    SubmissionFilter userAndStatusFilter = new SubmissionFilter();
    userAndStatusFilter.setUserId("user");
    userAndStatusFilter.setStatus(SubmissionStatus.DECLINED);

    SubmissionFilter anotherUserFilter = new SubmissionFilter();
    anotherUserFilter.setUserId("user1");

    Pageable pageRequest = PageRequest.of(0, 10);

    return Stream.of(
      Arguments.arguments(userFilter, pageRequest, 3),
      Arguments.arguments(userAndStatusFilter, pageRequest, 1),
      Arguments.arguments(anotherUserFilter, pageRequest, 0)
    );
  }

  @ParameterizedTest
  @MethodSource("shouldGetSubmissionsArguments")
  void shouldGetSubmissions(SubmissionFilter filter, Pageable pageable, int expectedTotal) {

    // Given
    long totalElementsBefore = submissionRepository.findAll(filter, pageable).getTotalElements();

    Submission submission1 = createSubmission();
    submission1.setStatus(SubmissionStatus.DECLINED);
    submissionRepository.save(submission1);

    Submission submission2 = createSubmission();
    submissionRepository.save(submission2);

    Submission submission3 = createSubmission();
    submissionRepository.save(submission3);

    // When
    Page<SubmissionValue> submissionValuePage = submissionRepository.findAll(filter, pageable);

    // Then
    assertEquals(expectedTotal + totalElementsBefore, submissionValuePage.getTotalElements());
  }

  @ParameterizedTest
  @MethodSource("shouldGetSubmissionsArguments")
  void shouldGetSubmissionsByProblem(SubmissionFilter filter, Pageable pageable, int expectedTotal) {

    // Given
    long totalElementsBefore = submissionRepository.findAll(filter, pageable).getTotalElements();

    Problem problem = new Problem();

    Submission submission1 = createSubmission();
    submission1.setProblem(problem);
    submission1.setStatus(SubmissionStatus.DECLINED);
    submissionRepository.save(submission1);

    Submission submission2 = createSubmission();
    submission2.setProblem(problem);
    submissionRepository.save(submission2);

    Submission submission3 = createSubmission();
    submission3.setProblem(problem);
    submissionRepository.save(submission3);

    // When
    Page<SubmissionValue> submissionValuePage = submissionRepository.findAllByProblem(filter, problem.getId(), pageable);

    // Then
    assertEquals(expectedTotal + totalElementsBefore, submissionValuePage.getTotalElements());
  }
}
