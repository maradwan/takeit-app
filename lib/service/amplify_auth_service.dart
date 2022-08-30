import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AmplifyAuthService {
  Future<String> getToken() async {
    final session = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    ) as CognitoAuthSession;

    return session.userPoolTokens!.idToken;
  }
}
