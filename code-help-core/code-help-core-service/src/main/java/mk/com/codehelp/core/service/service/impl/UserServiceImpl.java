package mk.com.codehelp.core.service.service.impl;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.domain.model.User;
import mk.com.codehelp.core.domain.repository.UserRepository;
import mk.com.codehelp.core.service.service.UserService;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

  private final UserRepository userRepository;

  @Override
  public User getByUserId(String id) {
    return userRepository.findById(id).orElseThrow();
  }

  @Override
  public User getOrCreate(String id, String username) {

    synchronized (userRepository) {
      return userRepository.findById(id).orElseGet(() -> {
        User newUser = new User();
        newUser.setUserId(id);
        newUser.setUsername(username);

        return userRepository.save(newUser);
      });
    }
  }
}
