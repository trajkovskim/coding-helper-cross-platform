package mk.com.codehelp.core.domain.resolvers;

import jakarta.annotation.Nonnull;
import java.util.Optional;

import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.repository.UserRepository;

@Component
@RequiredArgsConstructor
public class AuditorResolver implements AuditorAware<User> {

  private final UserRepository userRepository;

  @Override
  @Nonnull
  public Optional<User> getCurrentAuditor() {

    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    User currentUser = userRepository.findById(authentication.getName()).orElseThrow();

    return Optional.of(currentUser);
  }
}
