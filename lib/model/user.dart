import 'package:user_profile_management/model/address.dart';

class User {
  final String? id;
  final Address address;
  final String name, email, phone;

  User({
    this.id,
    required this.email,
    required this.address,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"] ?? "",
      id: json["id"].toString(),
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      address: Address.fromJson(json["address"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
        "address": address.toJson(),
      };

  @override
  String toString() =>
      "User(id: $id, name: $name, email: $email, phone: $phone, address: $address)";
}
