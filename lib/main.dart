import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/amplifyconfiguration.dart';
import 'package:travel_app/screens/confirm_email_screen.dart';
import 'package:travel_app/screens/confirm_reset_password_screen.dart';
import 'package:travel_app/screens/login_screen.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
import 'package:travel_app/screens/search_result_screen.dart';
import 'package:travel_app/screens/tabs_screen.dart';
import 'package:travel_app/screens/trip_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Take it',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: _amplifyConfigured
            ? const LoginScreen()
            : const CircularProgressIndicator(),
        routes: {
          ConfirmEmailScreen.routeName: (_) => const ConfirmEmailScreen(),
          ConfirmResetPasswordScreen.routeName: (_) =>
              const ConfirmResetPasswordScreen(),
          TabsScreen.routeName: (_) => const TabsScreen(),
          SearchResultScreen.routeName: (_) => const SearchResultScreen(),
          TripDetailsScreen.routeName: (_) => const TripDetailsScreen(),
          SaveTripScreen.routeName: (_) => const SaveTripScreen(),
        },
      ),
    );
  }

  Future<bool> isSignedIn() async {
    try {
      await Amplify.Auth.getCurrentUser();
      return true;
    } on AuthException catch (e) {
      return false;
    }
  }

  Future<void> _configureAmplify() async {
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      log(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android.",
      );
    }
  }
}
