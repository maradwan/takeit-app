import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/model/trip.dart';
import 'package:http/http.dart' as http;

class TripService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging/';

  Future<Trip?> save(Trip trip, String authToken) async {
    const url = '$gatewayUrl/weight';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(trip),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token",
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

  Future<List<Trip>> findTrips(String authToken) async {
    const url = '$gatewayUrl/weight';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token",
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
    final DateFormat formatter = DateFormat('dd.MM.yyyy');

    return Trip(
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

  final token =
      "eyJraWQiOiJcL3duekhcL0xvUGhUV3R4cDVHUnBDeTZHWUNlSFBrODNCaHNta1FWZzFUaU09IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiT1JYTTdGMHFnbG8tTTk0eWdYZHozdyIsInN1YiI6IjcwODU4YzU0LWFmYTYtNDVhMS1hYjQ1LWE0NTdjOGQ5MzQwOSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuZXUtd2VzdC0xLmFtYXpvbmF3cy5jb21cL2V1LXdlc3QtMV8wMnRZdTRwVXQiLCJjb2duaXRvOnVzZXJuYW1lIjoiYW1ya2hhbGVkIiwiYXVkIjoiN3FxZ29lanJqNHVtcGhxbHNzOTlrZWQ0cWoiLCJldmVudF9pZCI6IjgwNTk0Y2E2LWVmNGYtNDI3OS05MTFkLWI4OTc4ZWZmNmQ3OCIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNjYxNzgxMDA5LCJuYW1lIjoiQW1yIEtoYWxlZCIsImV4cCI6MTY2MTc4NDYwOSwiaWF0IjoxNjYxNzgxMDA5LCJqdGkiOiIwMjQzMTNkZi0yYWEwLTQ1ZGUtOTkxNS0xMTI5ZjYyYWJmNWQiLCJlbWFpbCI6ImFtcmtoYWxlZGNjZEBob3RtYWlsLmNvbSJ9.DdH_QdMroqOYraw4bwAJIL0WAkjOcAh957QhxwWpTOqDicUHaryif9NEGPncdLZxPPQkirBqdAb41RS-mek2B7tuAlr_hiEKvmZrAsgZedS-hVQnLEX_--0AKtGYaidqcTDIQRBH_V8OS6y2QcZ14JQTyUHEtK5dWc79K0aX36W4hoeYm2xxZt-L_V3iqcloEJxxwMF519GExCCuilSVuI5Y_6bTFLlLAWO2BU0HJatTmJi6n2wWmM9ugCUezdesGRDgGqNcfCKhXiGZym0l5RhGK337jbZ4Qi7BnGgGNh8WQ7Qoqw3PLame1VDzwGd9eSZu7NgvWsT2YT6LskxLiQ";
}
