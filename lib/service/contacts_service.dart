import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/service/amplify_auth_service.dart';

class ContactsService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging';

  final amplifyAuthService = AmplifyAuthService();

  Future<Contacts> save(Contacts contact) async {
    const url = '$gatewayUrl/contacts';
    try {
      final response = await http.post(
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

  Future<Contacts?> findContacts() async {
    const url = '$gatewayUrl/contacts';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );
      print(response.statusCode);
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
}
