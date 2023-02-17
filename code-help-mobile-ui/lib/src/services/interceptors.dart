import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BearerInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    const key = 'jwttoken';
    SharedPreferences.getInstance().then((storage) {
      if (storage.containsKey(key)) {
        options.headers['Authorization'] = 'Bearer ${storage.getString(key)}';
      }
    }).whenComplete(() => handler.next(options));
  }
}
