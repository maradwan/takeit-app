import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/util/app_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Future<String> _getName() async {
    final result = await Amplify.Auth.fetchUserAttributes();

    for (final element in result) {
      if (element.userAttributeKey == CognitoUserAttributeKey.name) {
        return element.value;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final name = snapshot.data;
        return Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.teal,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/take_it.png",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      const ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(FontAwesomeIcons.addressCard),
                        title: Text(
                          "Contact Info",
                          style: AppTheme.body,
                        ),
                      ),
                      const ListTile(
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.security),
                        title: Text(
                          "Terms and Polices",
                          style: AppTheme.body,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          await Amplify.Auth.signOut();
                          // ignore: use_build_context_synchronously
                          await Navigator.pushReplacementNamed(context, '/');
                        },
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.all(0),
                        leading: const Icon(Icons.logout),
                        title: const Text(
                          "Logout",
                          style: AppTheme.body,
                        ),
                      ),
                    ],
                  ).toList(),
                ),
              ),
              Container(
                color: Colors.red[300],
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.all(0),
                  leading: const Icon(FontAwesomeIcons.skull),
                  title: Text(
                    "Delete Your Account",
                    style: AppTheme.body.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}