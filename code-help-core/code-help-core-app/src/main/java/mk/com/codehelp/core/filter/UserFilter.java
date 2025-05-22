package mk.com.codehelp.core.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.service.service.UserService;
import mk.com.codehelp.core.service.util.AuthenticationUtil;

@Component
@WebFilter
@RequiredArgsConstructor
public class UserFilter extends OncePerRequestFilter {

  private final UserService userService;
  private final AuthenticationUtil authenticationUtil;

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

    String userId = authenticationUtil.getUserId();
    String username = authenticationUtil.getUsername();

    if (userId != null && username != null) {
      userService.getOrCreate(userId, username);
    }

    filterChain.doFilter(request, response);
  }
}
