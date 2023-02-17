package mk.com.codehelp.core.domain.repository;

//
//@Repository
//public interface UserRepository extends Neo4jRepository<User, String> {
//
//    @Query("match (s:Submission)-[ru:USER]->(u:User) with s, u where s.status = 'ACCEPTED' " +
//            "match (p:Problem)<-[rp:PROBLEM]-(s) with distinct u, p return u as user, count(p) as solved order by solved desc")
//    List<UserWithTotalSolvedQuery> findAllWithTotalAcceptedSubmissions();
//}
