class UserModel {
  String firstName;
  String lastName;
  String email;
  String? photoUrl;
  String gender;
  String category;
  String token;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.photoUrl,
    required this.gender,
    required this.category,
    required this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : firstName = json['firstName'],
      lastName = json['lastName'],
      email = json['email'],
      photoUrl = json['photo'],
      gender = json['gender'] ?? "MALE",
      category = json['category'] ?? "BASIC",
      token = json['token'];
}

class ProviderModel {
  String firstName;
  String lastName;
  String serviceType;
  String? photoUrl;

  ProviderModel({
    required this.firstName,
    required this.lastName,
    required this.serviceType,
    this.photoUrl,
  });

  ProviderModel.fromJson(Map<String, dynamic> json)
    : firstName = json['firstName'],
      lastName = json['lastName'],
      serviceType = json['serviceType'],
      photoUrl = json['photo'];
}
