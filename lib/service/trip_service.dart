import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/model/trip.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/service/amplify_auth_service.dart';

class TripService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging/';

  final amplifyAuthService = AmplifyAuthService();

  Future<Trip> save(Trip trip) async {
    const url = '$gatewayUrl/weight';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(trip),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      final body = json.decode(response.body);

      return _mapToTrip(body);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<Trip> updateTrip(Trip trip) async {
    final url = '$gatewayUrl/weight/${trip.created}';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(trip),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      final body = json.decode(response.body);

      return _mapToTrip(body);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> deleteTrip(String created) async {
    final url = '$gatewayUrl/weight/$created';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Trip>> findTrips() async {
    const url = '$gatewayUrl/weight';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);

      List<Trip> trips = [];
      final fetchedTrips = body['Items'] as List;

      for (var tripResponse in fetchedTrips) {
        trips.add(_mapToTrip(tripResponse));
      }

      return trips;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Trip _mapToTrip(Map<String, dynamic> tripResponse) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Trip(
      tripResponse['created'],
      tripResponse['username'],
      formatter.parse(tripResponse['acceptfrom']),
      formatter.parse(tripResponse['acceptto']),
      formatter.parse(tripResponse['trdate']),
      tripResponse['fromcity'],
      tripResponse['tocity'],
      tripResponse['currency'],
      _mapToItems(tripResponse['allowed'] as Map<String, dynamic>),
    );
  }

  List<Item> _mapToItems(Map<String, dynamic> itemsResopnse) {
    List<Item> items = [];
    for (var key in itemsResopnse.keys) {
      var itemValue = itemsResopnse[key] as Map<String, dynamic>;
      items.add(Item(
        key,
        double.parse(itemValue['cost']),
        double.parse(itemValue['kg']),
      ));
    }
    return items;
  }
}
