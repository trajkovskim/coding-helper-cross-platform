import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/services/codehelp/api.dart';

class UserService {
  const UserService();

  Future<UserStatistics> getStatistics() {
    return USER_API.getStatistics().then((response) => response.data!);
  }
}
