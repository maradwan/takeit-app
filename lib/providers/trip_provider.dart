import 'package:flutter/foundation.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/trip_service.dart';

class TripProvider with ChangeNotifier {
  TripProvider(this.token);

  String? token;
  final tripService = TripService();
  List<Trip> _items = [];

  List<Trip> get trips {
    return [..._items];
  }

  Future<void> fetchTrips() async {
    _items = await tripService.findTrips(token!);
    notifyListeners();
  }
}
