import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class ConfirmResetPasswordScreen extends StatefulWidget {
  static const String routeName = '/confirm-reset-password';

  const ConfirmResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ConfirmResetPasswordScreenState createState() =>
      ConfirmResetPasswordScreenState();
}

class ConfirmResetPasswordScreenState
    extends State<ConfirmResetPasswordScreen> {
  late final LoginData _data;
  final _controller = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final argMap = ModalRoute.of(context)!.settings.arguments as LoginData;
      setState(() {
        _data = argMap;
      });
    });
    super.initState();

    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
    _newPasswordController.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  void _resetPassword(
      BuildContext context, String code, String password) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: _data.name,
        newPassword: password,
        confirmationCode: code,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password changed successfully. Please log in',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );

      Navigator.of(context).pushReplacementNamed('/');
    } on AuthException catch (e) {
      _showError(context, '${e.message} - ${e.underlyingException}');
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
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          elevation: 12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: const EdgeInsets.all(30),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Enter new password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
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
                          _resetPassword(
                            context,
                            _controller.text,
                            _newPasswordController.text,
                          );
                        }
                      : null,
                  elevation: 4,
                  color: Theme.of(context).primaryColor,
                  disabledColor: Colors.teal.shade200,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Text(
                    'Back',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
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
