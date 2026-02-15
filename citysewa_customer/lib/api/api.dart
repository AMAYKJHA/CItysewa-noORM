import "dart:convert";
import "package:http/http.dart" as http;

import "package:citysewa_customer/api/models.dart";

const baseUrl = "https://citysewa2.onrender.com/api/v1";

String parseErrorMessage(dynamic error) {
  if (error is Map) {
    for (final message in error.values) {
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      } else if (message is String) {
        return message;
      }
    }
  }
  if (error is String) {
    return error;
  }
  return "Something went wrong. Please try again.";
}

class AuthService {
  final modUrl = "accounts/provider";

  // login
  Future<LoginResponse> login(String email, String password) async {
    final body = {"email": email, "password": password};
    final url = Uri.parse("$baseUrl/$modUrl/login");
    try {
      final response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse(
          success: true,
          message: "Login Successful",
          user: User(
            id: data["id"],
            firstName: data["first_name"],
            lastName: data["last_name"],
            gender: data["gender"],
            token: data["token"],
            photo: data["photo"],
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        final r = LoginResponse(
          success: false,
          message: parseErrorMessage(data),
        );
        return r;
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  //Register
  Future<RegisterResponse> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "gender": "Male",
    };
    final url = Uri.parse("$baseUrl/$modUrl/register");
    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        return RegisterResponse(
          success: true,
          message: "Registration successful",
        );
      } else {
        final data = jsonDecode(response.body);
        return RegisterResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  //fetch provider
  Future<User?> getProvider(int id) async {
    final url = Uri.parse("$baseUrl/$modUrl/$id");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        User user = User(
          id: data["id"],
          firstName: data["first_name"],
          lastName: data["last_name"],
          gender: data["gender"],
          token: data["token"],
          photo: data["photo"],
        );
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Verify provider
  Future<VerificationResponse> verifyProvider(
    int id,
    String phoneNumber,
    String docNumber,
    String docType,
    String photoPath,
    String docPath,
  ) async {
    final url = Uri.parse("$baseUrl/$modUrl/submit-verification");
    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['id'] = id.toString();
      request.fields['phone_number'] = phoneNumber;
      request.fields['document_number'] = docNumber;
      request.fields['document_type'] = docType;

      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      request.files.add(await http.MultipartFile.fromPath('document', docPath));

      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response.statusCode == 200) {
        return VerificationResponse(
          success: true,
          message: "Verification form submitted successfully.",
        );
      } else {
        final data = jsonDecode(response.body);
        return VerificationResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return VerificationResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}

class ServiceManager {
  final modUrl = "services";

  // list services
  Future<ServiceListResponse> listServices(String serviceType) async {
    final url = Uri.parse("$baseUrl/$modUrl?service_type=$serviceType");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Service> serviceList = [];
        for (Map<String, dynamic> item in data) {
          Service service = Service(
            id: item["id"],
            title: item["title"],
            serviceType: item["service_type"],
            price: item["price"],
            priceUnit: item["price_unit"],
            providerName: item["provider_name"],
            thumbnail: item["thumbnail"],
          );
          serviceList.add(service);
        }
        return ServiceListResponse(
          success: true,
          message: "Services requested are here.",
          serviceList: serviceList,
        );
      } else {
        final data = jsonDecode(response.body);
        return ServiceListResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return ServiceListResponse(
        success: false,
        message: "Something went wrong.",
      );
    }
  }

  Future<ServiceResponse> getService(int serviceId) async {
    final url = Uri.parse("$baseUrl/$modUrl/$serviceId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ServiceResponse(
          success: true,
          message: "Service added successfully.",
          service: Service(
            id: data["id"],
            title: data["title"],
            serviceType: data["service_type"],
            price: data["price"],
            priceUnit: data["price_unit"],
            providerName: data["provider_name"],
            thumbnail: data["thumbnail"],
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        return ServiceResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return ServiceResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}

class BookingManager {
  final modUrl = "bookings";

  // list bookings
  Future<BookingListResponse> listBookings(int customerId) async {
    final url = Uri.parse("$baseUrl/$modUrl?customer_id=$customerId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Booking> bookingList = [];
        for (Map<String, dynamic> item in data) {
          final booking = Booking(
            id: item["id"],
            serviceId: item["service_id"],
            customerId: item["customer_id"],
            addressId: item["address_id"],
            bookingDate: item["booking_date"],
            bookingTime: item["booking_time"],
            status: item["status"],
          );
          bookingList.add(booking);
        }
        return BookingListResponse(
          success: true,
          message: "Your bookings are here.",
          bookingList: bookingList,
        );
      } else {
        final data = jsonDecode(response.body);
        return BookingListResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return BookingListResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  // get booking stats
  Future<BookingStats> bookingStats(int customerId) async {
    final url = Uri.parse("$baseUrl/$modUrl/stats?customer_id=$customerId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookingStats = BookingStats(
          success: true,
          message: "Stats fetched successfully.",
          pending: data["pending"],
          completed: data["completed"],
          cancelled: data["cancelled"],
        );
        return bookingStats;
      } else {
        final data = jsonDecode(response.body);
        return BookingStats(success: false, message: parseErrorMessage(data));
      }
    } catch (e) {
      return BookingStats(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}

class AddressManager {
  final modUrl = "addresses";

  Future<AddressListResponse> listAddresses(int customerId) async {
    final url = Uri.parse("$baseUrl/$modUrl?customer_id=$customerId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Address> addressList = [];
        for (Map<String, dynamic> item in data) {
          final address = Address(
            id: item["id"],
            userId: item["user_id"],
            landmarks: item["landmarks"],
            location: item["location"],
          );
          addressList.add(address);
        }
        return AddressListResponse(
          success: true,
          message: "Addresses fetched successfully.",
          addressList: addressList,
        );
      } else {
        final data = jsonDecode(response.body);
        return AddressListResponse(
          success: false,
          message: parseErrorMessage(data),
        );
      }
    } catch (e) {
      return AddressListResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
