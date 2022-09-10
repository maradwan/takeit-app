class TripSearchKey {
  final String created;
  final String fromCity;
  final String trDate;
  final String username;

  TripSearchKey(
    this.created,
    this.fromCity,
    this.trDate,
    this.username,
  );

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'fromcity': fromCity,
      'trdate': trDate,
      'username': username,
    };
  }

  static TripSearchKey fromJson(Map<String, dynamic> json) {
    return TripSearchKey(
      json['created'],
      json['fromcity'],
      json['trdate'],
      json['username'],
    );
  }
}
