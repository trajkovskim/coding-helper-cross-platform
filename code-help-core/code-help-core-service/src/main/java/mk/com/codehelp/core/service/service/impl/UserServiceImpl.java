package mk.com.codehelp.core.service.service.impl;

import lombok.RequiredArgsConstructor;
import mk.com.codehelp.core.service.service.UserService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
//  public User findByEmail(String email) {
//    return this.userRepository.findById(email).orElseThrow(() -> new UserNotFoundException(email));
//  }
//
//  @Override
//  public String updateAvatar(MultipartFile image, String userEmail) throws IOException {
//    if (image == null)
//      throw new InvalidFileException();
//    var user = this.findByEmail(userEmail);
//    var dir = new File("src/main/resources/public/avatars/");
//    dir.mkdirs();
//    List.of(dir.listFiles(file -> file.getName().startsWith(userEmail + "-avatar"))).forEach(File::delete);
//    var fileName = userEmail + "-avatar" + image.getOriginalFilename().substring(image.getOriginalFilename().lastIndexOf("."));
//    image.transferTo(Path.of(dir.getPath(), fileName));
//    user.setAvatarImage(fileName);
//    this.userRepository.save(user);
//    return fileName;
//  }
//
//  @Override
//  public List<UsernameWithTotalSolvedDto> findAllWithTotalAcceptedSubmissions() {
//    Function<UserWithTotalSolvedQuery, UsernameWithTotalSolvedDto> function =
//        x -> new UsernameWithTotalSolvedDto(x.getUser().getUserName(), x.getSolved());
//    return userRepository.findAllWithTotalAcceptedSubmissions()
//        .stream()
//        .map(function)
//        .collect(Collectors.toList());
//  }

}
