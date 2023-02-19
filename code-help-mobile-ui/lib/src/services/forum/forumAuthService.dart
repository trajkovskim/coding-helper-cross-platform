import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:dio/src/response.dart';
import 'package:dio/src/dio_error.dart';

class ForumAuthService {
  static const _prefix = "Bearer";
  static const _authorizationHeader = "Authorization";

  static ForumAuthService? _instance;

  final _forumAuthApi = getForumAuthApi();

  late String _accessToken = "";
  late String _refreshToken = "";

  static ForumAuthService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static createForumAuthService() {
    _instance = ForumAuthService._construct();

    return _instance;
  }

  ForumAuthService._construct() {
    _authenticate();
  }

  Future<Response<T>> requestWithAuth<T>(Future<Response<T>> Function(Map<String, dynamic>) request) async {
    try {
      return await request.call(_getAuthHeaders());
    } on DioError catch (e) {
      if (e.response?.statusCode == 401 | 403) {
        return _refreshTokenAndRetry(request);
      }
    }

    throw Error();
  }

  Future<Response<T>> _refreshTokenAndRetry<T>(Future<Response<T>> Function(Map<String, dynamic>) request) async {
    await _refreshAuthentication();
    return request.call(_getAuthHeaders());
  }

  _authenticate() {
    final response = _login();
    handleAuthResponse(response);
  }

  _refreshAuthentication() {
    final response = _refresh();
    handleAuthResponse(response);
  }

  Future<Response<AuthResponse>> _login() async {
    final userCredentials = UserCredentialsBuilder()
      ..username = "admin"
      ..password = "password";

    return await _forumAuthApi.login(userCredentials: userCredentials.build());
  }

  Future<Response<AuthResponse>> _refresh() async {
    return await _forumAuthApi.refresh(headers: Map.fromEntries([_getRefreshHeader()]));
  }

  handleAuthResponse(Future<Response<AuthResponse>> response) {
    response.then((value) => {if (value.statusCode == 200 && value.data != null) initFromAuthResponse(value.data!)});
  }

  initFromAuthResponse(AuthResponse authResponse) {
    _accessToken = authResponse.accessToken;
    _refreshToken = authResponse.refreshToken;
  }

  Map<String, dynamic> _getAuthHeaders() {
    return Map.fromEntries([_getAuthHeader()]);
  }

  MapEntry<String, dynamic> _getAuthHeader() {
    return MapEntry(_authorizationHeader, "$_prefix $_accessToken");
  }

  MapEntry<String, dynamic> _getRefreshHeader() {
    return MapEntry(_authorizationHeader, "$_prefix $_refreshToken");
  }
}
