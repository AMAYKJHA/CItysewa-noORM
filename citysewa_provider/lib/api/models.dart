class LoginResponse {
  bool success = false;
  String message;
  User? user;

  LoginResponse({required this.success, required this.message, this.user});
}

class RegisterResponse {
  bool success = false;
  String message;

  RegisterResponse({required this.success, required this.message});
}

class VerificationResponse {
  bool success = false;
  String message;

  VerificationResponse({required this.success, required this.message});
}

class ServiceResponse {
  bool success = false;
  String message;
  List<Service>? serviceList;

  ServiceResponse({
    required this.success,
    required this.message,
    this.serviceList,
  });
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  bool verified;
  String? token;
  String? photo;
  String? description;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.verified,
    this.token,
    this.photo,
    this.description,
  });
}

class Service {
  final int id;
  int? providerId;
  final String title;
  final String serviceType;
  final int price;
  final String priceUnit;
  String? thumbnail;
  String? description;

  Service({
    required this.id,
    required this.title,
    required this.serviceType,
    required this.price,
    required this.priceUnit,
    this.thumbnail,
    this.providerId,
    this.description,
  });
}
