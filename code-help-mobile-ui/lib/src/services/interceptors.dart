import 'dart:convert';
import 'dart:io';

import 'package:coding_helper_cross_platform/src/services/codehelp/api.dart';
import 'package:dio/dio.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _setAuthorizationHeader(RequestOptions options, String? token) {
  if (token == null) {
    options.headers.remove('Authorization');
    return;
  }
  options.headers['Authorization'] = 'Bearer $token';
}

class BearerInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    const key = 'jwttoken';
    SharedPreferences.getInstance().then((storage) {
      if (storage.containsKey(key)) {
        _setAuthorizationHeader(options, storage.getString(key)!);
      }
    }).whenComplete(() => handler.next(options));
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type != DioErrorType.response || err.response?.statusCode != HttpStatus.unauthorized) {
      handler.next(err);
      return;
    }

    const tokenKey = UserToken.tokenKey;
    const userKey = UserToken.userKey;
    final storage = await SharedPreferences.getInstance();

    if (!storage.containsKey(userKey)) {
      handler.next(err);
      return;
    }

    try {
      final userJson = jsonDecode(storage.getString(userKey)!);
      final user = Credential.fromJson(userJson);
      final tokenResponse = await user.getTokenResponse(true);
      await storage.setString(tokenKey, tokenResponse.accessToken!);
      _setAuthorizationHeader(err.requestOptions, tokenResponse.accessToken);

      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (ex) {
      await storage.remove(userKey);
      await storage.remove(tokenKey);

      handler.next(err);
    }
  }
}

class UserTokenData {
  var _hasToken = false;
  String? _username;

  UserTokenData(this._username, this._hasToken);

  String? getUsername() {
    return _username;
  }

  bool hasToken() {
    return _hasToken;
  }
}

class UserToken {
  static final _instance = UserToken();
  static const tokenKey = 'jwttoken';
  static const userKey = 'user';

  static UserTokenData data = UserTokenData(null, false);

  static final List<Function(UserTokenData)> _subscribers = [];

  getInstance() {
    return _instance;
  }

  static initialize() async {
    final storage = await SharedPreferences.getInstance();

    var userInfo = await getUserInfo(storage);

    _setData(userInfo?.preferredUsername, storage.containsKey(tokenKey));
  }

  static Future<UserInfo?> getUserInfo(SharedPreferences storage) async {
    final encodedUser = storage.getString(userKey);

    if (encodedUser == null) {
      return null;
    }

    final userJson = jsonDecode(encodedUser);
    final user = Credential.fromJson(userJson);
    final userInfo = await user.getUserInfo();

    return userInfo;
  }

  static _setData(String? username, bool hasToken) {
    data = UserTokenData(username, hasToken);
    _notify(data);
  }

  static subscribe(Function(UserTokenData) handler) {
    _subscribers.add(handler);
    return () => _subscribers.remove(handler);
  }

  static set(UserTokenData newData) {
    _setData(newData.getUsername(), newData.hasToken());
  }

  static update(UserTokenData Function(UserTokenData) updater) {
    data = updater(data);
    _notify(data);
  }

  static UserTokenData get() {
    return data;
  }

  static _notify(UserTokenData newData) {
    _subscribers.forEach((handlers) => handlers(newData));
  }
}
