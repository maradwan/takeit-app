import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:travel_app/service/amplify_auth_service.dart';
import 'package:travel_app/util/env_config.dart';
import 'package:travel_app/util/http_util.dart';

class ContactsService {
  final amplifyAuthService = AmplifyAuthService();

  Future<Contacts> save(Contacts contact) async {
    const url = '$gatewayUrl/contacts';
    try {
      final response = await httpClient.post(
        Uri.parse(url),
        body: json.encode(contact.toJson()),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);
      return Contacts.fromJson(body);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<Contacts?> findLoggedInUserContacts() async {
    const url = '$gatewayUrl/contacts';
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );
      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);
      return Contacts.fromJson(body['Items'][0]);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<Contacts?> findContacts(
      String tripId, String username, bool isForTraveler) async {
    final user = isForTraveler ? 'traveler' : 'requester';
    final url = '$gatewayUrl/contacts/$user/${tripId}_$username';
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode >= 400) {
        throw HttpException(response.body);
      }

      final body = json.decode(response.body);
      final fetchRequests = body['Items'] as List;

      return fetchRequests.isNotEmpty
          ? Contacts.fromJson(fetchRequests[0])
          : null;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
