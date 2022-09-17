import 'package:intl/intl.dart';
import 'package:travel_app/model/trip.dart';

class TravelerShareRquest {
  final String created;
  final String fromUser;
  final DateTime trDate;
  final String tripId;
  final String username;

  TravelerShareRquest(
    this.created,
    this.fromUser,
    this.trDate,
    this.tripId,
    this.username,
  );

  static TravelerShareRquest fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return TravelerShareRquest(
      json['created'],
      json['fromuser'],
      formatter.parse(json['trdate']),
      json['tripid'],
      json['username'],
    );
  }
}
