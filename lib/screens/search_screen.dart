import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/search_result_screen.dart';

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
                    text: '$takeoffCity, $takeoffCountry',
                    placeholderText: 'From: City',
                    showPlaceHolder:
                        takeoffCountry == null || takeoffCountry == null,
                    icon: Icons.flight_takeoff,
                    onClick: () async {
                      final result = await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
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
                    text: '$landingCity, $landingCountry',
                    placeholderText: 'To: City',
                    showPlaceHolder:
                        landingCountry == null || landingCity == null,
                    icon: Icons.flight_land,
                    onClick: () async {
                      final result = await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
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

class InputPlaceholder extends StatelessWidget {
  final String text;
  final IconData icon;
  final String placeholderText;
  final bool showPlaceHolder;
  final Function() onClick;

  const InputPlaceholder({
    Key? key,
    required this.text,
    required this.icon,
    required this.placeholderText,
    required this.showPlaceHolder,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              showPlaceHolder ? placeholderText : text,
              style: showPlaceHolder
                  ? TextStyle(fontSize: 18, color: Colors.grey[500])
                  : const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> cities = [
    {"country": "Egypt", "city": "Cairo"},
    {"country": "Egypt", "city": "Alexandria"},
    {"country": "Egypt", "city": "Aswan"},
    {"country": "Egypt", "city": "Hurghada"},
    {"country": "Egypt", "city": "Tanta"},
    {"country": "Egypt", "city": "Ismailia"},
    {"country": "Germany", "city": "Berlin"},
    {"country": "Germany", "city": "Hanover"},
    {"country": "Germany", "city": "Munich"},
    {"country": "Germany", "city": "Hamburg"},
    {"country": "Germany", "city": "Düsseldorf"},
    {"country": "Germany", "city": "Stuttgart"},
  ];
  List<Map<String, String>> filtered = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(15),
        itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.flag),
              title: RichText(
                text: TextSpan(
                  text: filtered[i]['city']!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  children: [
                    TextSpan(
                        text: "  ${filtered[i]['country']!}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ))
                  ],
                ),
              ),
            ),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: filtered.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filtered = query.isEmpty
        ? cities
        : cities
            .where((item) =>
                item['city']!.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.separated(
        padding: const EdgeInsets.all(15),
        itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                Navigator.pop(context, {
                  'country': filtered[i]['country']!,
                  'city': filtered[i]['city']!
                });
              },
              child: ListTile(
                leading: Flag.fromCode(
                    filtered[i]['country']! == 'Egypt'
                        ? FlagsCode.EG
                        : FlagsCode.DE,
                    height: 24,
                    width: 24),
                title: RichText(
                  text: TextSpan(
                    text: filtered[i]['city']!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    children: [
                      TextSpan(
                          text: "  ${filtered[i]['country']!}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ))
                    ],
                  ),
                ),
              ),
            ),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: filtered.length);
  }
}
