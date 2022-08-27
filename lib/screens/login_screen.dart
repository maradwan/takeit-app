import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:travel_app/screens/confirm_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignedIn = false;
  SignupData? _signupData;

  Future<String?>? _onLogin(LoginData data) async {
    try {
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
      return null;
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String?>? _onSignup(SignupData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: data.name!,
          CognitoUserAttributeKey.name: data.additionalSignupData!['name']!
        }),
      );
      _signupData = data;
      return null;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      body: FlutterLogin(
        title: 'Welcome',
        additionalSignupFields: const [
          UserFormField(
            keyName: 'name',
            displayName: 'Name',
          ),
        ],
        onLogin: _onLogin,
        onRecoverPassword: (String email) async {
          return 'sss';
        },
        onSignup: (data) => _onSignup(data),
        theme: LoginTheme(
          primaryColor: Theme.of(context).primaryColor,
        ),
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? '/dashboard' : ConfirmEmailScreen.routeName,
            arguments: SignupData,
          );
        },
      ),
    );
  }
}
