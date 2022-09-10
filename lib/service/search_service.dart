import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/model/paged_result.dart';

import 'package:travel_app/model/trip.dart';
import 'package:travel_app/model/trip_search_key.dart';
import 'package:travel_app/service/amplify_auth_service.dart';

class SearchService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging';

  final amplifyAuthService = AmplifyAuthService();

  Future<PagedResult<Trip, TripSearchKey>> search(String? fromCity,
      String? toCity, int pageSize, TripSearchKey? tripSearchKey) async {
    String url;
    if (fromCity != null && toCity != null) {
      url = '$gatewayUrl/fromto/${fromCity}_$toCity';
    } else if (fromCity != null) {
      url = '$gatewayUrl/fromcity/$fromCity';
    } else if (toCity != null) {
      url = '$gatewayUrl/tocity/$toCity';
    } else {
      throw const HttpException('invalid arguments');
    }

    String? lastkey = tripSearchKey != null
        ? Uri.encodeComponent(json.encode(tripSearchKey.toJson()))
        : null;
    url = '$url?limit=$pageSize${lastkey != null ? '&lastkey=$lastkey' : ''}';

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
      final lastKey = body['LastEvaluatedKey'];

      return PagedResult(
          trips, lastKey != null ? TripSearchKey.fromJson(lastKey) : null);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Trip _mapToTrip(Map<String, dynamic> tripResponse) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Trip(
      tripResponse['created'],
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
