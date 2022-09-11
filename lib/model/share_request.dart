import 'package:intl/intl.dart';

class ShareRquest {
  final String created;
  final String fromUser;
  final DateTime trDate;
  final String tripId;
  final String username;

  ShareRquest(
    this.created,
    this.fromUser,
    this.trDate,
    this.tripId,
    this.username,
  );

  static ShareRquest fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return ShareRquest(
      json['created'],
      json['fromuser'],
      formatter.parse(json['trdate']),
      json['tripid'],
      json['username'],
    );
  }
}
