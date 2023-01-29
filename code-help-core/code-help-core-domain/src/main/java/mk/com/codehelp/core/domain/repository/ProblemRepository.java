package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Problem;
import mk.com.codehelp.core.domain.queries.ProblemByLikesQuery;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

@Repository
public interface ProblemRepository extends Neo4jRepository<Problem, Long> {
    @Override
    @Query("match (p:Problem) optional match (p)-[r:IN_CONTEST]->(c:Contest) with p, c where c is null or c.status='CLOSED' return p")
    List<Problem> findAll();

    @Query("match (problem)-[r:WITH_CATEGORY]->(category:Category) with problem, category where category.name in $categories " +
            "optional match (problem:Problem)-[r:IN_CONTEST]->(contest:Contest) with problem, contest where contest is null or contest.status='CLOSED' return problem;")
    List<Problem> findAllByCategory_NameIn(Collection<String> categories);

    @Query("match (p:Problem) " +
            "optional match (p)-[r:IN_CONTEST]->(c:Contest) with p, c where c is null or c.status='CLOSED' " +
            "optional match (p)-[r:LIKED_BY]->(m:User) with p as problem, count(r) as likes return problem, likes order by likes desc")
    List<ProblemByLikesQuery> findTop10ByOrderByLikes();

    @Override
    @Query("match (problem:Problem) with problem " +
            "optional match (problem)<-[r:PROBLEM]-(submission:Submission) with problem, submission " +
            "match (problem:Problem) where ID(problem)=$id detach delete problem, submission")
    void deleteById(Long id);
}
