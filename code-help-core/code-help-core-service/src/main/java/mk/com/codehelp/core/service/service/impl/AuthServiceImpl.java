package mk.com.codehelp.core.service.service.impl;

import lombok.AllArgsConstructor;
import mk.com.codehelp.core.service.service.AuthService;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.repository.UserRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class AuthServiceImpl implements AuthService {
  private final UserRepository userRepository;

  @Override
  public User loadUserByUsername(String email) throws UsernameNotFoundException {
    return userRepository.findById(email).orElseThrow(() -> new UsernameNotFoundException(email));
  }
}
