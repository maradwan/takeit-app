import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/search_provider.dart';
import 'package:travel_app/widgets/weight_card.dart';

class SearchResultScreen extends StatefulWidget {
  static const String routeName = '/search-result';

  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      isLoading = true;
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final fromCity = argMap['fromCity'] as String?;
      final toCity = argMap['toCity'] as String?;

      try {
        final searchProvider =
            Provider.of<SearchProvider>(context, listen: false);
        searchProvider.searchTrips(fromCity, toCity);
      } on HttpException catch (e) {
        debugPrint(e.message);
      }

      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Avaliable Trips'),
        titleTextStyle: const TextStyle(fontSize: 18),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 60,
                child: LoadingIndicator(
                  strokeWidth: 1,
                  indicatorType: Indicator.ballPulse,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Consumer<SearchProvider>(
                builder: (ctx, searchProvider, _) {
                  final trips = searchProvider.trips;
                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (ctx, i) {
                      final kg = trips[i]
                          .allowedItems
                          .map((item) => item.kg)
                          .reduce((prev, current) => prev + current);
                      return WeightCard(
                        from: trips[i].fromCity.split(',')[0],
                        to: trips[i].toCity.split(',')[0],
                        arrival: trips[i].trDate,
                        kg: kg,
                      );
                    },
                  );
                },
              )),
    );
  }
}
