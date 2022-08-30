import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CitySearchDelegate extends SearchDelegate {
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
