import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/global_provider.dart';
import 'package:travel_app/screens/confirm_email_screen.dart';
import 'package:travel_app/screens/confirm_reset_password_screen.dart';
import 'package:travel_app/screens/privacy_screen.dart';
import 'package:travel_app/screens/t_and_c.dart';
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
      await Amplify.Auth.signOut();
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
      if (_isSignedIn && mounted) {
        final globalProvider =
            Provider.of<GlobalProvider>(context, listen: false);
        await globalProvider.loadUserdata();
      }

      return null;
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      } else if (e.message.contains('User not confirmed')) {
        Navigator.of(context).pushReplacementNamed(
          _isSignedIn ? TabsScreen.routeName : ConfirmEmailScreen.routeName,
          arguments: {
            'username': data.name,
            'password': data.password,
          },
        );
      }
      return 'Incorrect Email or Password';
    }
  }

  Future<String?>? _onSignup(SignupData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: SignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: data.name!,
          CognitoUserAttributeKey.name: data.additionalSignupData!['name']!
        }),
      );
      _signupData = data;
      return null;
    } on AuthException catch (e) {
      debugPrint(e.message);
      //todo must handle error to be more ambiguous
      if (e.message.contains('Username already exists')) {
        return 'Email already exists';
      } else if (e.message.contains('The password given is invalid')) {
        return 'Password should be at least 6 characters';
      }
      return 'Something went wrong, try again';
    }
  }

  Future<String?>? _onRecoverPassword(String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
      if (!mounted) return null;

      if (res.nextStep.updateStep ==
          AuthResetPasswordStep.confirmResetPasswordWithCode) {
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
        passwordValidator: (password) {
          if (password == null || password.length < 6) {
            return 'Password should be at least 6 charcters';
          }
          return null;
        },
        onLogin: _onLogin,
        onRecoverPassword: _onRecoverPassword,
        onSignup: (data) => _onSignup(data),
        theme: LoginTheme(
          primaryColor: Theme.of(context).primaryColor,
          textFieldStyle: const TextStyle(color: Colors.black),
        ),
        onSubmitAnimationCompleted: () {
          _showLoginDialog(context);
        },
      ),
    );
  }



  void _showLoginDialog(BuildContext context) {
    bool _termsChecked = false;
    bool _privacyChecked = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Please agree to the Terms and Conditions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _termsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(TAndC.routeName);
                          },
                          child: const Text(
                            'I agree to the Terms and Conditions',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _privacyChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _privacyChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(PrivacyScreen.routeName);
                          },
                          child: const Text(
                            'I agree to the privacy policy',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  onPressed: _privacyChecked
                      ? () {
                    // Navigator.of(context).pop();

                    Map<String, String> args = {
                      'username': _signupData?.name ?? '',
                      'password': _signupData?.password ?? '',
                    };
                    Navigator.of(context).pushReplacementNamed(
                      _isSignedIn ? TabsScreen.routeName : ConfirmEmailScreen.routeName,
                      arguments: args,
                    );
                  }
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }


}
