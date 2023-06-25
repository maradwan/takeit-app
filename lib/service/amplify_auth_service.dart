import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AmplifyAuthService {
  Future<String> getToken() async {
    final session = await Amplify.Auth.fetchAuthSession(
      options: const FetchAuthSessionOptions(forceRefresh: true),
    ) as CognitoAuthSession;
    return session.userPoolTokensResult.value.idToken.raw;
  }
}
