package mk.com.codehelp.core.domain.model;

import lombok.Data;
import mk.com.codehelp.core.domain.enums.Gender;
import mk.com.codehelp.core.domain.enums.Role;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Data
@Node
public class User implements UserDetails {
  @Id
  private String email;

  private String username;
  private String password;
  private String firstName;
  private String lastName;
  private String avatarImage;

  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private LocalDate birthday;

  private Gender gender;
  private Role role;

  @Relationship(value = "SUBMISSION", direction = Relationship.Direction.OUTGOING)
  private List<Submission> submissions;
  @Relationship(value = "LIKES")
  private List<Problem> likedProblems;
  @Relationship(value = "FAVORITE")
  private List<Problem> favorites;

  public User() {
    this.avatarImage = "defaultUser.png";
    this.role = Role.USER;
    this.submissions = new ArrayList<>();
    this.likedProblems = new ArrayList<>();
    this.favorites = new ArrayList<>();
  }

  @Override
  public Collection<? extends GrantedAuthority> getAuthorities() {
    return Collections.singletonList(this.role);
  }

  @Override
  public String getPassword() {
    return password;
  }

  @Override
  public String getUsername() {
    return this.getEmail();
  }

  public String getUserName() {
    return this.username;
  }

  @Override
  public boolean isAccountNonExpired() {
    return true;
  }

  @Override
  public boolean isAccountNonLocked() {
    return true;
  }

  @Override
  public boolean isCredentialsNonExpired() {
    return true;
  }

  @Override
  public boolean isEnabled() {
    return true;
  }

}
