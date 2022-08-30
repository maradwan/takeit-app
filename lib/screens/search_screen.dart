import 'package:flutter/material.dart';
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
                    showPlaceHolder:
                        takeoffCountry == null || takeoffCountry == null,
                    icon: Icons.flight_takeoff,
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
                    placeholderText: 'To: City',
                    showPlaceHolder:
                        landingCountry == null || landingCity == null,
                    icon: Icons.flight_land,
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
                        onSurface: Colors.teal,
                      ),
                      onPressed: takeoffCity != null || landingCity != null
                          ? () {
                              Navigator.pushNamed(
                                  context, SearchResultScreen.routeName);
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
