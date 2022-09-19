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
    this.linkedIn,
    this.telegram,
    this.twitter,
  );

  static Contacts fromJson(Map<String, dynamic> json) {
    return Contacts(
      json['created'],
      json['name'],
      json['mobile'],
      json['e-mail'],
      json['facebook'],
      json['instagram'],
      json['linkedin'],
      json['telegram'],
      json['twitter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'e-mail': email,
      'facebook': facebook,
      'instagram': instagram,
      'linkedin': linkedIn,
      'telegram': telegram,
      'twitter': twitter,
    };
  }
}
