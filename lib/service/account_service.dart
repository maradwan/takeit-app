import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:travel_app/service/amplify_auth_service.dart';

class AccountService {
  static const gatewayUrl =
      'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging';

  final amplifyAuthService = AmplifyAuthService();

  Future<void> deleteAccount() async {
    const url = '$gatewayUrl/account';

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
}