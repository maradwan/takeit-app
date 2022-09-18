class RequesterShareRquest {
  final String created;
  final String tripId;
  final String username;

  RequesterShareRquest(
    this.created,
    this.tripId,
    this.username,
  );

  static RequesterShareRquest fromJson(Map<String, dynamic> json) {
    return RequesterShareRquest(
      json['created'],
      json['tripid'],
      json['username'],
    );
  }
}
