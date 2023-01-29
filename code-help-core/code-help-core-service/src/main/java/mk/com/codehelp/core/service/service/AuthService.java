package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

public interface AuthService extends UserDetailsService {
  @Override
  User loadUserByUsername(String email) throws UsernameNotFoundException;

}
