import 'dart:convert';

import 'package:coding_helper_cross_platform/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../context/index.dart';
import '../../i18n/i18n.dart';

const String DEFAULT_IMAGE_URL = 'https://media.istockphoto.com/id/1300845620' +
    '/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.webp' +
    '?s=612x612&w=is&k=20&c=PJjJWl0njGyow3AefY7KVNuhkbw5r2skqFiCFM5kyic=';

class UserFrame extends StatelessWidget {
  final authService = const AuthService();
  const UserFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedContext = Provider.of<SharedContext>(context);
    final userData = sharedContext.userData;

    final t = getTranslation(context, 'profile');

    Future<void> handleLogin() async {
      final storage = await SharedPreferences.getInstance();
      final user = await authService.authenticate();
      final tokenResponse = await user.getTokenResponse();
      final token = tokenResponse.accessToken;

      final userJson = jsonEncode(user);

      storage.setString('user', userJson);
      storage.setString('jwttoken', token!);
      storage.setString('logout-url', user.generateLogoutUrl().toString());
      sharedContext.setToken(token);

      final userInfo = await user.getUserInfo();
      sharedContext.setUserData(
        userInfo.preferredUsername,
        userInfo.picture.toString(),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userData?.image ?? DEFAULT_IMAGE_URL,
                ),
              ),
              const SizedBox(height: 5),
              Text(userData?.username ?? t('notLoggedIn')),
              const SizedBox(height: 20),
              if (!sharedContext.isAuthenticated)
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text('Login'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
