package mk.com.codehelp.core.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import mk.com.codehelp.core.domain.enums.Gender;
import mk.com.codehelp.core.domain.enums.Role;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
  private String username;
  private String firstName;
  private String lastName;
  private String avatarImage;
  private Gender gender;
  private Role role;
}
