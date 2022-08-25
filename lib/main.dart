import 'package:flutter/material.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
import 'package:travel_app/screens/search_result_screen.dart';
import 'package:travel_app/screens/tabs_screen.dart';
import 'package:travel_app/screens/trip_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const TabsScreen(),
        routes: {
          SearchResultScreen.routeName: (_) => const SearchResultScreen(),
          TripDetailsScreen.routeName: (_) => const TripDetailsScreen(),
          SaveTripScreen.routeName: (_) => const SaveTripScreen(),
        },
      ),
    );
  }
}
