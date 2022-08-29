import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:travel_app/screens/confirm_email_screen.dart';
import 'package:travel_app/screens/confirm_reset_password_screen.dart';
import 'package:travel_app/screens/tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isSignedIn = false;
  SignupData? _signupData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn && mounted) {
        Navigator.pushReplacementNamed(context, TabsScreen.routeName);
      }
    });

    super.initState();
  }

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

  Future<String?>? _onRecoverPassword(String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
      if (!mounted) return null;

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushNamed(
          ConfirmResetPasswordScreen.routeName,
          arguments: LoginData(name: email, password: ''),
        );
      }
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
        onRecoverPassword: _onRecoverPassword,
        onSignup: (data) => _onSignup(data),
        theme: LoginTheme(
          primaryColor: Theme.of(context).primaryColor,
        ),
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? TabsScreen.routeName : ConfirmEmailScreen.routeName,
            arguments: _signupData,
          );
        },
      ),
    );
  }
}
