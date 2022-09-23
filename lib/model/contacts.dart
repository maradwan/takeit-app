class Contacts {
  final String? created;
  final String? name;
  final String? mobile;
  final String? email;
  final String? facebook;
  final String? instagram;
  final String? linkedIn;
  final String? telegram;
  final String? twitter;

  Contacts(
    this.created,
    this.name,
    this.mobile,
    this.email,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedIn,
    this.telegram,
  );

  static Contacts fromJson(Map<String, dynamic> json) {
    return Contacts(
      json['created'],
      json['name'],
      json['mobile'],
      json['e-mail'],
      json['fb'],
      json['instagram'],
      json['twitter'],
      json['linkedin'],
      json['telegram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'e-mail': email,
      'fb': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'linkedin': linkedIn,
      'telegram': telegram,
    };
  }
}
