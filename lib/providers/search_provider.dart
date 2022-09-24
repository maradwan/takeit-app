import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/model/trip_search_key.dart';
import 'package:travel_app/service/search_service.dart';

class SearchProvider with ChangeNotifier {
  final int _pageSize = 6;
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
      final trips = await removeLoggedInUserTrips(pagedTrips.content);
      _trips.addAll(trips);
      remaining = remaining - trips.length;
    } while (remaining > 0 && _lastKey != null);

    notifyListeners();
  }

  Future<List<Trip>> removeLoggedInUserTrips(List<Trip> trips) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    return trips.where((trip) => trip.username != userId).toList();
  }
}
