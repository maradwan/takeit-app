class TripSearchKey {
  final String created;
  final String? fromCity;
  final String? toCity;
  final String? fromTo;
  final String trDate;
  final String username;

  TripSearchKey(
    this.created,
    this.fromCity,
    this.toCity,
    this.fromTo,
    this.trDate,
    this.username,
  );

  Map<String, dynamic> toJson() {
    final json = {
      'created': created,
      'trdate': trDate,
      'username': username,
    };
    if (fromCity != null) {
      json['fromcity'] = fromCity!;
    } else if (toCity != null) {
      json['tocity'] = toCity!;
    } else if (fromTo != null) {
      json['fromto'] = fromTo!;
    }
    return json;
  }

  static TripSearchKey fromJson(Map<String, dynamic> json) {
    return TripSearchKey(
      json['created'],
      json['fromcity'],
      json['tocity'],
      json['fromto'],
      json['trdate'],
      json['username'],
    );
  }
}
