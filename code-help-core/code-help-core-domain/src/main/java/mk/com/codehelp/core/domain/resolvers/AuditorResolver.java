package mk.com.codehelp.core.domain.resolvers;

import jakarta.annotation.Nonnull;
import java.util.Optional;

import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import mk.com.codehelp.core.domain.model.User;

@Component
public class AuditorResolver implements AuditorAware<User> {

  @Override
  @Nonnull
  public Optional<User> getCurrentAuditor() {

    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    User user = new User(authentication.getName());

    return Optional.of(user);
  }
}
