import 'package:flutter/cupertino.dart';
import 'package:travel_app/util/http_util.dart';

class TAndCService {
  Future<String> scrapTC() async {
    try {
      final url = Uri.parse(
          'https://medium.com/@mustafatahirhussein/these-quick-tips-will-surely-help-you-to-build-a-better-flutter-app-6db93c1095b6');
      final response = await httpClient.get(url);
      return response.body;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
