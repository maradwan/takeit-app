import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/screens/save_trip_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        if (element.userAttributeKey == CognitoUserAttributeKey.name) {
          setState(() {
            name = element.value;
          });
          break;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: Text(name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SaveTripScreen.routeName);
            },
            icon: const Icon(FontAwesomeIcons.plus),
          ),
          IconButton(
            onPressed: () async {
              await Amplify.Auth.signOut();
              if (!mounted) return;

              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
