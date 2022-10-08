import 'package:flutter/cupertino.dart';
import 'package:travel_app/util/http_util.dart';

class TAndCService {
  Future<String> scrapTC() async {
    try {
      final url = Uri.parse('https://gotake-it.com/terms.html');
      final response = await httpClient.get(url);
      return response.body;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<String> scrapPrivacy() async {
    try {
      final url = Uri.parse('https://gotake-it.com/privacy.html');
      final response = await httpClient.get(url);
      return response.body;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
