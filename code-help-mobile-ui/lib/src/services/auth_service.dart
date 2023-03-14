import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client_io.dart';

class AuthService {
  const AuthService();
  static const CLIENT_ID = "code-help-flutter";
  static const ISSUER_URI = String.fromEnvironment("AUTH_ISSUER_URL");

  Future<void> _urlLauncher(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<Credential> authenticate() async {
    final uri = Uri.parse(ISSUER_URI);
    final issuer = await Issuer.discover(uri);
    final client = Client(issuer, CLIENT_ID);

    final authenticator = Authenticator(
      client,
      port: 4000,
      urlLancher: _urlLauncher,
    );

    final user = await authenticator.authorize();

    await closeInAppWebView();

    return user;
  }

  Future<void> logout(String logoutUrl) async {
    await _urlLauncher(logoutUrl);
    UserToken.initialize();
    await closeInAppWebView();
  }
}
