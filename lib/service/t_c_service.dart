import 'package:flutter/cupertino.dart';
import 'package:travel_app/util/http_util.dart';

class TAndCService {
  Future<String> scrapTC() async {
    try {
      final url = Uri.parse(
          'https://gotake-it.com/privacy.html?fbclid=IwAR0dUsQbPpHRxtUZE29o8T5NEz2By3p3LfFVflwiYDXW9nC4RF7pNfrd4eI');
      final response = await httpClient.get(url);
      return response.body;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<String> scrapPrivacy() async {
    try {
      final url = Uri.parse(
          'https://gotake-it.com/privacy.html?fbclid=IwAR0dUsQbPpHRxtUZE29o8T5NEz2By3p3LfFVflwiYDXW9nC4RF7pNfrd4eI');
      final response = await httpClient.get(url);
      return response.body;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
