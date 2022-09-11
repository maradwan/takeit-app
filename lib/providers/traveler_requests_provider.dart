import 'package:flutter/foundation.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/share_request.dart';
import 'package:travel_app/service/share_request_service.dart';

class TravelerRequestsProvider with ChangeNotifier {
  final _shareRequestService = ShareRequestService();
  List<ShareRquest> _requests = [];

  List<ShareRquest> get requests {
    return [..._requests];
  }

  Future<void> findRequests(RequestStatus requestStatus) async {
    _requests = await _shareRequestService.findTravelerPendingRequests();
    notifyListeners();
  }
}
