import 'package:flutter/foundation.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/service/share_request_service.dart';

class RequesterRequestsProvider with ChangeNotifier {
  final _shareRequestService = ShareRequestService();
  List<RequesterShareRquest> _requests = [];

  List<RequesterShareRquest> get requests {
    return [..._requests];
  }

  Future<void> findRequests(RequestStatus requestStatus) async {
    _requests = await _shareRequestService.findRequesterPendingRequests();
    notifyListeners();
  }
}
