import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:travel_app/service/amplify_auth_service.dart';
import 'package:travel_app/util/env_config.dart';
import 'package:http/http.dart' as http;

class DevicesService {
  final amplifyAuthService = AmplifyAuthService();

  // update fcm token with device id and return success or failure
  Future updateToken(String fcmToken, String deviceId) async {
    const url = '$gatewayUrl/devices';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'token': fcmToken,
          'deviceID': deviceId,
        }),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer ${await amplifyAuthService.getToken()}",
        },
      );


      if (response.statusCode >= 400) {
        print("Failed to send data ${response.statusCode} ${response.body}");
      } else {
        print("Data sent successfully ${response.statusCode} ");

      }
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

}
