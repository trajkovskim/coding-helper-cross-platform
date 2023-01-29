package mk.com.codehelp.core.domain.model;

import lombok.Builder;
import lombok.Value;
import mk.com.codehelp.core.domain.enums.Gender;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

@Value
@Builder
public class RegisterModel {
  private String username;

  private String email;

  private String password;

  private String firstName;

  private String lastName;

  private Gender gender;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
  private LocalDate birthday;
}
