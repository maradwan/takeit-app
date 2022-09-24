import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/service/account_service.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/widgets/input_widget.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const String routeName = '/delete-account';
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool enable = false;
  bool isDeleting = false;

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red[600],
                ),
                const SizedBox(width: 10),
                Text(
                  'Are you sure?',
                  style: AppTheme.title.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Contacts, trips, sent/recieed requests',
              style: AppTheme.body,
            ),
            const SizedBox(height: 5),
            const Text(
              'will be deleted and cannot be restored',
              style: AppTheme.subtitle,
            ),
            Padding(
              padding: const EdgeInsets.all(15).copyWith(top: 20, bottom: 10),
              child: InputWidget(
                //suffixIcon: FontAwesomeIcons.phone,
                hintText: 'Type "Delete it"',
                //keyboardType: TextInputType.phone,
                onchaged: (value) {
                  setState(() {
                    enable =
                        value != null && value.toLowerCase() == 'delete it';
                  });
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton.icon(
                onPressed: !enable || isDeleting
                    ? null
                    : () async {
                        setState(() {
                          isDeleting = true;
                        });
                        try {
                          await AccountService().deleteAccount();
                          await Amplify.Auth.signOut();
                          // ignore: use_build_context_synchronously
                          await Navigator.pushReplacementNamed(context, '/');
                        } on HttpException catch (e) {
                          debugPrint(e.message);
                          _showSnackbar(
                              'Something went wrong, try again', 'error');
                        }
                        setState(() {
                          isDeleting = false;
                        });
                      },
                icon: const Icon(FontAwesomeIcons.skull),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  disabledForegroundColor: Colors.red[200],
                  disabledBackgroundColor: Colors.red[50],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
