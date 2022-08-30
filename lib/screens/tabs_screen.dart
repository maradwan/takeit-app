import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/trip_provider.dart';
import 'package:travel_app/screens/sent_packages_screen.dart';
import 'package:travel_app/screens/profile_screen.dart';
import 'package:travel_app/screens/received_packages_screen.dart';
import 'package:travel_app/screens/search_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = '/tabs';

  const TabsScreen({Key? key}) : super(key: key);

  @override
  TabsScreenState createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    const SearchScreen(),
    const RecievedPackagesScreen(),
    const SentPackagesScreen(),
    ChangeNotifierProvider(
      create: (_) => TripProvider(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[200],
        iconSize: 24,
        currentIndex: _selectedIndex,
        elevation: 1,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.magnifyingGlass), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.suitcaseRolling), label: 'Recivied'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.paperPlane), label: 'Sent'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}
