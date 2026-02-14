import 'dart:async';

class ApiResponse {
  bool success = false;
  String message;

  ApiResponse({required this.success, required this.message});
}

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

class ServiceListResponse {
  bool success = false;
  String message;
  List<Service>? serviceList;

  ServiceListResponse({
    required this.success,
    required this.message,
    this.serviceList,
  });
}

class BookingListResponse extends ApiResponse {
  List<Booking>? bookingList;

  BookingListResponse({
    required super.success,
    required super.message,
    this.bookingList,
  });
}

class BookingStats {
  bool success = false;
  String message;
  int pending;
  int completed;
  int cancelled;

  BookingStats({
    required this.success,
    required this.message,
    this.pending = 0,
    this.completed = 0,
    this.cancelled = 0,
  });
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  String? token;
  String? photo;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.token,
    this.photo,
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

class Booking {
  final int id;
  final int serviceId;
  final int customerId;
  final int addressId;
  final String bookingDate;
  final String bookingTime;
  final String status;

  Booking({
    required this.id,
    required this.serviceId,
    required this.customerId,
    required this.addressId,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
  });
}
