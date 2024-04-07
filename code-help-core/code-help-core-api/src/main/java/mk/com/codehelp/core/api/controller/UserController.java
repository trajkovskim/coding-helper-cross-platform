package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.api.mappers.UserMapper;
import mk.com.codehelp.core.domain.dto.UserStatisticsDto;
import mk.com.codehelp.core.rest.api.UserApi;
import mk.com.codehelp.core.rest.model.UserStatistics;
import mk.com.codehelp.core.service.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final UserService userService;
  private final UserMapper userConverter;

  @Override
  public ResponseEntity<UserStatistics> getStatistics(String authorization) {
    String name = SecurityContextHolder.getContext().getAuthentication().getName();
    UserStatisticsDto userStatistics = userService.getStatistics(name);
    UserStatistics entry = userConverter.convertUserStatistics(userStatistics);
    return ResponseEntity.ok(entry);
  }
}
