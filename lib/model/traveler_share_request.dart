class TravelerShareRquest {
  final String created;
  final String tripId;
  final String username;

  TravelerShareRquest(
    this.created,
    this.tripId,
    this.username,
  );

  static TravelerShareRquest fromJson(Map<String, dynamic> json) {
    return TravelerShareRquest(
      json['created'],
      json['tripid'],
      json['username'],
    );
  }
}
