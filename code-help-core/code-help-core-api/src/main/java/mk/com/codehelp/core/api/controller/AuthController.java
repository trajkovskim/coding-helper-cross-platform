package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.UserMapper;
import mk.com.codehelp.core.domain.model.RegisterModel;
import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.rest.api.AuthApi;
import mk.com.codehelp.core.rest.model.LoginRequest;
import mk.com.codehelp.core.rest.model.RegisterRequest;
import mk.com.codehelp.core.service.exceptions.InvalidCredentialsException;
import mk.com.codehelp.core.service.service.AuthService;
import mk.com.codehelp.core.service.service.UserService;
import mk.com.codehelp.core.service.service.impl.JwtTokenService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

@CodingHelperController
@RequiredArgsConstructor
public class AuthController implements AuthApi {
  private final AuthenticationManager authenticationManager;
  private final JwtTokenService jwtTokenService;
  private final AuthService authService;
  private final UserService userService;
  private final UserMapper userConverter;


  @Override
  public ResponseEntity<Void> register(RegisterRequest registerRequest) {
    RegisterModel model = userConverter.convertRegisterRequest(registerRequest);
    userService.register(model);
    return ResponseEntity.noContent().build();
  }

  @Override
  public ResponseEntity<String> login(LoginRequest loginRequest) {
    try {
      UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
              loginRequest.getEmail(),
              loginRequest.getPassword()
      );
      authenticationManager.authenticate(authToken);
    } catch (DisabledException | BadCredentialsException e) {
      throw new InvalidCredentialsException();
    }
    User userDetails = authService.loadUserByUsername(loginRequest.getEmail());
    String token = jwtTokenService.generateToken(userDetails);
    return ResponseEntity.ok(token);
  }
}
