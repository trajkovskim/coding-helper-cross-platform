package mk.com.codehelp.core.domain.model;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class LoginModel {
  String email;
  String password;
}
