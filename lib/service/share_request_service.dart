import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/model/traveler_share_request.dart';
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

      if (response.statusCode == 404) {
        return;
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> acceptRequest(String requestId) async {
    final url = '$gatewayUrl/share-request/traveler/$requestId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode == 404) {
        return;
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      print(json.decode(response.body));
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> declineRequest(String requestId) async {
    final url = '$gatewayUrl/share-request/traveler/$requestId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode == 404) {
        return;
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }
      print(json.decode(response.body));
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<List<TravelerShareRquest>> findTravelerRequests(
      RequestStatus requestStatus) async {
    final url = '$gatewayUrl/share-request/traveler/${requestStatus.name}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);
      final fetchedRequests = body['Items'] as List;
      return fetchedRequests
          .map((request) => TravelerShareRquest.fromJson(request))
          .toList();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<List<RequesterShareRquest>> findRequesterRequests(
      RequestStatus requestStatus) async {
    final url = '$gatewayUrl/share-request/requester/${requestStatus.name}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);
      final fetchedRequests = body['Items'] as List;
      return fetchedRequests
          .map((request) => RequesterShareRquest.fromJson(request))
          .toList();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
