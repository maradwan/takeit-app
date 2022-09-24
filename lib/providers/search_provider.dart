import 'package:flutter/foundation.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/model/trip_search_key.dart';
import 'package:travel_app/service/search_service.dart';

class SearchProvider with ChangeNotifier {
  final int _pageSize = 10;
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
    _lastKey = null;
    _trips = [];
  }

  Future<void> searchTrips(String? fromCity, String? toCity) async {
    var remaining = _pageSize;
    do {
      var pagedTrips =
          await _searchService.search(fromCity, toCity, remaining, _lastKey);
      _hasMore = pagedTrips.lastEvaluatedKey != null;
      _lastKey = pagedTrips.lastEvaluatedKey;
      _trips.addAll(pagedTrips.content);
      remaining = remaining - pagedTrips.content.length;
    } while (remaining > 0 && _lastKey != null);

    notifyListeners();
  }
}
