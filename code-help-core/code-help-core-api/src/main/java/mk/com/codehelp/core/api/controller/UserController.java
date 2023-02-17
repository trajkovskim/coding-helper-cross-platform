package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;

@CodingHelperController
@RequiredArgsConstructor
public class UserController {
//  private final UserService userService;
//  private final UserMapper userConverter;
//
//  @PostMapping("/user/upload-avatar")
//  public String uploadAvatar(
//      @RequestPart("file") MultipartFile file
//  ) throws IOException {
//    String email = SecurityContextHolder.getContext().getAuthentication().getName();
//    return userService.updateAvatar(file, email);
//  }
//
//  @GetMapping("/users-with-total-accepted")
//  ResponseEntity<List<UsernameWithTotalSolvedDto>> usersWithTotalSolved() {
//    List<mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto> data =
//        userService.findAllWithTotalAcceptedSubmissions();
//    List<UsernameWithTotalSolvedDto> entries = userConverter.convertListOfUsernameWithTotalSolvedToRest(data);
//    return ResponseEntity.ok(entries);
//  }
}
