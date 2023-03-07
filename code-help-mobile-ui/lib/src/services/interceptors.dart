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
    if (err.type != DioErrorType.response ||
        err.response?.statusCode != HttpStatus.unauthorized) {
      handler.next(err);
      return;
    }

    const tokenKey = 'jwttoken';
    const userKey = 'user';
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
