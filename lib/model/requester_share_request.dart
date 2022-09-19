import 'package:intl/intl.dart';

class RequesterShareRquest {
  final String created;
  final String tripId;
  final DateTime dtime;
  final String username;

  RequesterShareRquest(
    this.created,
    this.tripId,
    this.dtime,
    this.username,
  );

  static RequesterShareRquest fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd-hh-mm-ss');

    return RequesterShareRquest(
      json['created'],
      json['tripid'],
      formatter.parse(json['dtime']),
      json['username'],
    );
  }
}
