
class User {
  String email;
  String name;
  String? urlPhoto;
  String? phoneNumber;

  User({
    required this.email,
    required this.name,
    this.urlPhoto,
    this.phoneNumber
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"],
      name: json["name"],
      urlPhoto: json["urlPhoto"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "urlPhoto": urlPhoto,
      "phoneNumber": phoneNumber,
    };
  }
}
