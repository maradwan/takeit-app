import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:travel_app/screens/tabs_screen.dart';
import 'package:travel_app/util/app_theme.dart';

class ConfirmEmailScreen extends StatefulWidget {
  static const String routeName = '/confirm-email';

  const ConfirmEmailScreen({Key? key}) : super(key: key);

  @override
  ConfirmEmailScreenState createState() => ConfirmEmailScreenState();
}

class ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  late final String? _username;
  late final String? _password;
  late final Timer? timer;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      setState(() {
        _username = argMap['username'];
        _password = argMap['password'];
      });
      timer = Timer.periodic(const Duration(seconds: 3), (_) => tryToLogin());
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void tryToLogin() async {
    try {
      await Amplify.Auth.signOut();
      final user = await Amplify.Auth.signIn(
        username: _username!,
        password: _password,
      );

      if (user.isSignedIn && mounted) {
        timer?.cancel();
        Navigator.pushReplacementNamed(context, TabsScreen.routeName);
      }
    } on AuthException catch (_) {
      return;
    }
  }

  void _resendCode(String? username) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: username ?? '');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Confirmation link resent. Check your email',
              style: TextStyle(fontSize: 15)),
        ),
      );
    } on AuthException catch (e) {
      _showError(context, e.message);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Email',
                  style: AppTheme.title.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We sent a confirmation link to your email',
                  style: AppTheme.body,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Click on the link to confirm your email',
                  style: AppTheme.body,
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    _resendCode(_username);
                  },
                  elevation: 4,
                  color: Theme.of(context).primaryColor,
                  disabledColor: Colors.teal.shade200,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
