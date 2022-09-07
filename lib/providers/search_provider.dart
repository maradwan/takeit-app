import 'package:flutter/foundation.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/model/trip_search_key.dart';
import 'package:travel_app/service/search_service.dart';

class SearchProvider with ChangeNotifier {
  int _pageSize = 6;
  bool _hasMore = false;
  TripSearchKey? _lastKey;
  final _searchService = SearchService();
  List<Trip> _trips = [];

  List<Trip> get trips {
    return [..._trips];
  }

  bool get hasMore {
    return _hasMore;
  }

  void reset() {
    _hasMore = false;
    _trips = [];
  }

  Future<void> searchTrips(String? fromCity, String? toCity) async {
    var pagedTrips = await _searchService.search(fromCity, toCity, 11, null);
    _hasMore = pagedTrips.lastEvaluatedKey != null;
    _lastKey = pagedTrips.lastEvaluatedKey;
    _trips.addAll(pagedTrips.content);

    pagedTrips = await _searchService.search(fromCity, toCity, 11, _lastKey);
    _trips = pagedTrips.content;

    notifyListeners();
  }
}
