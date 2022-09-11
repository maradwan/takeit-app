import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/service/amplify_auth_service.dart';

class ShareRequestService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging';

  final amplifyAuthService = AmplifyAuthService();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> createRequest(
    String traveler,
    String tripId,
    DateTime arrivalDate,
  ) async {
    const url = '$gatewayUrl/share-request';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'traveleruser': traveler,
          'tripid': tripId,
          'trdate': formatter.format(arrivalDate),
        }),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      final body = json.decode(response.body);
      print(body);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}