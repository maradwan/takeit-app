import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/screens/save_trip_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Amr Khaled'),
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
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(FontAwesomeIcons.gear),
          )
        ],
      ),
      body: Container(),
    );
  }
}
