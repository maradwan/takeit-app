import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/global_provider.dart';
import 'package:travel_app/providers/search_provider.dart';
import 'package:travel_app/screens/trip_details_screen.dart';
import 'package:travel_app/widgets/info_label.dart';
import 'package:travel_app/widgets/weight_card.dart';

class SearchResultScreen extends StatefulWidget {
  static const String routeName = '/search-result';

  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final _scrollController = ScrollController();
  bool isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      initSearchResult();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          final searchProvider =
              Provider.of<SearchProvider>(context, listen: false);

          if (searchProvider.hasMore) {
            searchTrips();
          }
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initSearchResult() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.reset();
    setState(() {
      isLoading = true;
    });
    await searchTrips();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchTrips() async {
    final argMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final fromCity = argMap['fromCity'] as String?;
    final toCity = argMap['toCity'] as String?;

    try {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      await searchProvider.searchTrips(fromCity, toCity);
    } on HttpException catch (e) {
      debugPrint(e.message);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

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
          : RefreshIndicator(
              onRefresh: () => initSearchResult(),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Consumer<SearchProvider>(
                    builder: (ctx, searchProvider, _) {
                      final trips = searchProvider.trips;
                      return trips.isEmpty
                          ? Center(
                              child: Text(
                                'No trips found',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: trips.length,
                              itemBuilder: (ctx, i) {
                                if ((i == trips.length - 1) &&
                                    searchProvider.hasMore) {
                                  return const Center(
                                    child: SizedBox(
                                      width: 40,
                                      child: LoadingIndicator(
                                        strokeWidth: 1,
                                        indicatorType: Indicator.ballPulse,
                                      ),
                                    ),
                                  );
                                }
                                return WeightCard(
                                  trip: trips[i],
                                  info:
                                      globalProvider.userId == trips[i].username
                                          ? const InfoLabel(
                                              label: 'Your trip',
                                            )
                                          : null,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, TripDetailsScreen.routeName,
                                        arguments: trips[i]);
                                  },
                                );
                              },
                            );
                    },
                  )),
            ),
    );
  }
}
