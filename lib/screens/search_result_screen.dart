import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/search_service.dart';
import 'package:travel_app/widgets/weight_card.dart';

class SearchResultScreen extends StatefulWidget {
  static const String routeName = '/search-result';

  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isInit = true;
  List<Trip> trips = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      isLoading = true;
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final fromCity = argMap['fromCity'] as String?;
      final toCity = argMap['toCity'] as String?;
      final result = await SearchService().search(fromCity, toCity);
      setState(() {
        trips = result;
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
              child: ListView.builder(
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
              ),
            ),
    );
  }
}
