import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/amplifyconfiguration_prod.dart';
import 'package:travel_app/screens/privacy_screen.dart';
import 'package:travel_app/util/env_config.dart';
import 'package:travel_app/amplifyconfiguration_dev.dart';
import 'package:travel_app/providers/global_provider.dart';
import 'package:travel_app/providers/search_provider.dart';
import 'package:travel_app/providers/traveler_requests_provider.dart';
import 'package:travel_app/screens/confirm_email_screen.dart';
import 'package:travel_app/screens/confirm_reset_password_screen.dart';
import 'package:travel_app/screens/delete_account_screen.dart';
import 'package:travel_app/screens/login_screen.dart';
import 'package:travel_app/screens/requester_request_contact_info_screen.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
import 'package:travel_app/screens/search_result_screen.dart';
import 'package:travel_app/screens/t_and_c.dart';
import 'package:travel_app/screens/tabs_screen.dart';
import 'package:travel_app/screens/traveler_request_contact_info_screen.dart';
import 'package:travel_app/screens/trip_details_screen.dart';
import 'package:travel_app/screens/contacts_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return ChangeNotifierProvider(
      create: (_) => GlobalProvider(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Take it',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.teal,
          ),
          home: _amplifyConfigured
              ? const LoginScreen()
              : Scaffold(
                  backgroundColor: Colors.teal,
                  body: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            color: Colors.teal[300],
                          ),
                        ),
                      ),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 85,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/images/take_it.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          routes: {
            ConfirmEmailScreen.routeName: (_) => const ConfirmEmailScreen(),
            ConfirmResetPasswordScreen.routeName: (_) =>
                const ConfirmResetPasswordScreen(),
            TabsScreen.routeName: (_) => const TabsScreen(),
            SearchResultScreen.routeName: (_) => ChangeNotifierProvider(
                  create: (_) => SearchProvider(),
                  child: const SearchResultScreen(),
                ),
            TripDetailsScreen.routeName: (_) => const TripDetailsScreen(),
            SaveTripScreen.routeName: (_) => const SaveTripScreen(),
            TravelerRequestContactInfoScreen.routeName: (_) =>
                ChangeNotifierProvider(
                  create: (_) => TravelerRequestsProvider(),
                  child: const TravelerRequestContactInfoScreen(),
                ),
            ContactsScreen.routeName: (_) => const ContactsScreen(),
            RequesterRequestContactInfoScreen.routeName: (_) =>
                const RequesterRequestContactInfoScreen(),
            DeleteAccountScreen.routeName: (_) => const DeleteAccountScreen(),
            TAndC.routeName: (_) => const TAndC(),
            PrivacyScreen.routeName: (_) => const PrivacyScreen(),
          },
        ),
      ),
    );
  }

  Future<bool> isSignedIn() async {
    try {
      await Amplify.Auth.getCurrentUser();
      return true;
    } on AuthException catch (_) {
      return false;
    }
  }

  Future<void> _configureAmplify() async {
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    try {
      debugPrint('active profile: $activeProfile');
      await Amplify.configure(
          activeProfile == Profile.dev ? amplifyconfigDev : amplifyconfigProd);
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
