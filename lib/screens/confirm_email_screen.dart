import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:travel_app/screens/tabs_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  static const String routeName = '/confirm-email';

  const ConfirmEmailScreen({Key? key}) : super(key: key);

  @override
  ConfirmEmailScreenState createState() => ConfirmEmailScreenState();
}

class ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  late final SignupData _data;
  final _controller = TextEditingController();
  bool _isEnabled = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final argMap = ModalRoute.of(context)!.settings.arguments as SignupData;
      setState(() {
        _data = argMap;
      });
    });

    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
    super.initState();
  }

  void _verifyCode(SignupData data, String code) async {
    try {
      await Amplify.Auth.signOut();
      final res = await Amplify.Auth.confirmSignUp(
        username: data.name!,
        confirmationCode: code,
      );

      if (res.isSignUpComplete) {
        // Login user
        final user = await Amplify.Auth.signIn(
            username: data.name!, password: data.password);

        if (user.isSignedIn && mounted) {
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        }
      }
    } on AuthException catch (e) {
      _showError(context, e.message);
    }
  }

  void _resendCode(SignupData data) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: data.name!);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Confirmation code resent. Check your email',
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Enter confirmation code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: _isEnabled
                      ? () {
                          _verifyCode(_data, _controller.text);
                        }
                      : null,
                  elevation: 4,
                  color: Theme.of(context).primaryColor,
                  disabledColor: Colors.teal.shade200,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text(
                    'VERIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _resendCode(_data);
                  },
                  child: const Text(
                    'Resend code',
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
