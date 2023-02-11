import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/services/api.dart';

class AuthService {
  const AuthService();

  Future<String> login(String email, String password) {
    LoginRequestBuilder builder = LoginRequestBuilder()
      ..email = email
      ..password = password;

    return AUTH_API
        .login(loginRequest: builder.build())
        .then((value) => value.data!);
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required Gender gender,
    required Date date,
  }) {
    RegisterRequestBuilder builder = RegisterRequestBuilder()
      ..firstName = firstName
      ..lastName = lastName
      ..email = email
      ..password = password
      ..username = username
      ..gender = gender
      ..birthday = date;

    return AUTH_API.register(registerRequest: builder.build());
  }
}
