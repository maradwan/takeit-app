import 'package:flutter/material.dart';
import 'package:travel_app/screens/main_drawer.dart';
import 'package:travel_app/screens/search_result_screen.dart';
import 'package:travel_app/widgets/city_search_delegate.dart';
import 'package:travel_app/widgets/input_place_holder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? takeoffCountry;
  String? takeoffCity;
  String? landingCountry;
  String? landingCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      drawer: const MainDrawer(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Find available trips",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0.27,
                color: Color.fromARGB(255, 81, 87, 88),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputPlaceholder(
                    padding: 15,
                    text: '$takeoffCity, $takeoffCountry',
                    placeholderText: 'From: City',
                    fontSize: 18,
                    showPlaceHolder:
                        takeoffCountry == null || takeoffCountry == null,
                    icon: Icons.flight_takeoff,
                    onClear: () {
                      setState(() {
                        takeoffCountry = null;
                        takeoffCity = null;
                      });
                    },
                    onClick: () async {
                      final result = await showSearch(
                        context: context,
                        delegate: CitySearchDelegate(),
                      );
                      if (result != null) {
                        setState(() {
                          takeoffCountry = result['country'];
                          takeoffCity = result['city'];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  InputPlaceholder(
                    padding: 15,
                    text: '$landingCity, $landingCountry',
                    fontSize: 18,
                    placeholderText: 'To: City',
                    showPlaceHolder:
                        landingCountry == null || landingCity == null,
                    icon: Icons.flight_land,
                    onClear: () {
                      setState(() {
                        landingCountry = null;
                        landingCity = null;
                      });
                    },
                    onClick: () async {
                      final result = await showSearch(
                        context: context,
                        delegate: CitySearchDelegate(),
                      );
                      if (result != null) {
                        setState(() {
                          landingCountry = result['country'];
                          landingCity = result['city'];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        disabledForegroundColor: Colors.teal[200],
                        disabledBackgroundColor: Colors.teal[50],
                      ),
                      onPressed: takeoffCity != null || landingCity != null
                          ? () {
                              Navigator.pushNamed(
                                  context, SearchResultScreen.routeName,
                                  arguments: {
                                    'fromCity': takeoffCity == null
                                        ? null
                                        : '$takeoffCity-$takeoffCountry',
                                    'toCity': landingCity == null
                                        ? null
                                        : '$landingCity-$landingCountry',
                                  });
                            }
                          : null,
                      child: const Text(
                        'Search',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
