import 'package:intl/intl.dart';

class RequesterShareRquest {
  final String created;
  final DateTime trDate;
  final String tripId;
  final String username;

  RequesterShareRquest(
    this.created,
    this.trDate,
    this.tripId,
    this.username,
  );

  static RequesterShareRquest fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return RequesterShareRquest(
      json['created'],
      formatter.parse(json['trdate']),
      json['tripid'],
      json['username'],
    );
  }
}
