import 'package:flutter/foundation.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/amplify_auth_service.dart';
import 'package:travel_app/service/trip_service.dart';

class TripProvider with ChangeNotifier {
  TripProvider();

  final tripService = TripService();
  final amplifyAuthService = AmplifyAuthService();

  final List<Trip> _activeTrips = [];

  final List<Trip> _archivedTrips = [];

  List<Trip> get activeTrips {
    return [..._activeTrips];
  }

  List<Trip> get archivedTrips {
    return [..._archivedTrips];
  }

  Future<void> insertTrip(Trip trip) async {
    _activeTrips.add(trip);
    notifyListeners();
  }

  Future<void> updateTrip(Trip updatedTrip, int index) async {
    _activeTrips[index] = updatedTrip;
    notifyListeners();
  }

  Future<void> deleteTrip(String created, int index) async {
    await tripService.deleteTrip(created);
    _activeTrips.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchTrips() async {
    final trips = await tripService.findTrips();
    for (var trip in trips) {
      final today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final trDate =
          DateTime(trip.trDate.year, trip.trDate.month, trip.trDate.day);

      if (trDate.isBefore(today)) {
        _archivedTrips.add(trip);
      } else {
        _activeTrips.add(trip);
      }
    }
    notifyListeners();
  }
}
