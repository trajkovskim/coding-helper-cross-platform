package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto;
import mk.com.codehelp.core.domain.model.LoginModel;
import mk.com.codehelp.core.domain.model.RegisterModel;
import mk.com.codehelp.core.rest.model.LoginRequest;
import mk.com.codehelp.core.rest.model.RegisterRequest;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {

  RegisterModel convertRegisterRequest(RegisterRequest registerRequest);

  LoginModel convertLoginRequest(LoginRequest loginRequest);

  UsernameWithTotalSolvedDto convertUsernameWithTotalSolved(UsernameWithTotalSolvedDto dto);

  mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto convertUsernameWithTotalSolved(
      mk.com.codehelp.core.rest.model.UsernameWithTotalSolvedDto dto
  );

  List<mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto> convertListOfUsernameWithTotalSolved(
      List<UsernameWithTotalSolvedDto> usernameWithTotalSolvedDtos
  );

  List<UsernameWithTotalSolvedDto> convertListOfUsernameWithTotalSolvedToRest(
      List<mk.com.codehelp.core.domain.dto.UsernameWithTotalSolvedDto> usernameWithTotalSolvedDtos
  );


  //UserDto toDto(User user);
}
