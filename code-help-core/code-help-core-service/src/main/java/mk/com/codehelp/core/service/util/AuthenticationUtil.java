package mk.com.codehelp.core.service.util;

import java.lang.reflect.InvocationTargetException;
import java.security.Principal;
import java.util.Map;
import java.util.Optional;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationUtil {

  private Optional<Authentication> getAuthentication() {

    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    if (authentication == null || !authentication.isAuthenticated()) {
      return Optional.empty();
    }

    return Optional.of(authentication);
  }

  public String getUserId() {

    return getAuthentication().map(Principal::getName).orElse(null);
  }

  private Optional<Map<String, String>> getClaims() {
    return getAuthentication()
      .map(Authentication::getPrincipal)
      .map(principal -> {
        try {
          return principal.getClass().getMethod("getClaims").invoke(principal);
        } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException ignored) {
          return null;
        }
      })
      .map(claims -> (Map<String, String>) claims);
  }

  public String getUsername() {
    return getClaims()
      .map(claims -> claims.get("preferred_username"))
      .orElse(null);
  }
}
