package mk.com.codehelp.core.domain.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import mk.com.codehelp.core.domain.model.Contest;
import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.value.ContestValue;

@Repository
public interface ContestRepository extends Neo4jRepository<Contest, Long> {

  @Query(value = """
    match (contest:Contest)
    optional match (contest)-[r_user:PARTICIPATES]-(user:User)
    with contest, user
    where (:#{#filters.name.length} = 0 or contest.name =~ :#{#filters.name})
      and (:#{#filters.status.length} = 0 or :#{#filters.status} = contest.status)
    return *, count(user) as participantsSize :#{orderBy(#pageable)} SKIP $skip LIMIT $limit""",
  countQuery = """
    match (contest:Contest)
    where (:#{#filters.name.length} = 0 or contest.name =~ :#{#filters.name})
      and (:#{#filters.status.length} = 0 or :#{#filters.status} = contest.status)
    return count(*)""")
  Page<ContestValue> findAll(ContestFilter filters, Pageable pageable);

  @Query(value = """
    match (contest:Contest)
    optional match (contest)-[r_user:PARTICIPATES]-(user:User)
    with contest, user
    where ID(contest) = $id
    return *, count(user) as participantsSize""")
  Optional<ContestValue> findContestById(Long id);
}
