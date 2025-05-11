package mk.com.codehelp.core.filters;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.repository.UserRepository;
import mk.com.codehelp.core.service.util.AuthenticationUtil;

@WebFilter
@Component
@RequiredArgsConstructor
public class AuthenticationFilter extends OncePerRequestFilter {

  private final UserRepository userRepository;

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
    String user = AuthenticationUtil.getUser();

    if (user != null) {

      User userObj = new User();
      userObj.setUsername(user);
      userRepository.save(userObj);
    }

    filterChain.doFilter(request, response);
  }
}
