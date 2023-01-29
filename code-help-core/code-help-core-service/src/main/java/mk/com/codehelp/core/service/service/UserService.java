package mk.com.codehelp.core.service.service;

import mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto;
import mk.com.codehelp.core.domain.model.RegisterModel;
import mk.com.codehelp.core.domain.model.User;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface UserService {
  List<User> findAll();

  User findByEmail(String email);

  void register(RegisterModel registerModel);

  String updateAvatar(MultipartFile image, String userEmail) throws IOException;

  List<UsernameWithTotalSolvedDto> findAllWithTotalAcceptedSubmissions();

}
