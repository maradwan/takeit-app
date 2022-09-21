import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';

class GlobalProvider with ChangeNotifier {
  String _name = '';

  String get name {
    return _name;
  }

  Future<void> loadUserdata() async {
    final result = await Amplify.Auth.fetchUserAttributes();
    for (final element in result) {
      if (element.userAttributeKey == CognitoUserAttributeKey.name) {
        _name = element.value;
        break;
      }
    }
    notifyListeners();
  }
}
