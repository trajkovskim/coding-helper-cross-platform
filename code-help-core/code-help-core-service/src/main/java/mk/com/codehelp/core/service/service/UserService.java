package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.model.User;

public interface UserService {

  User getByUserId(String userId);

  User getOrCreate(String userId, String username);
}
