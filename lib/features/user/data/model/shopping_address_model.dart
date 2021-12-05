import 'package:get/get.dart';

class ShoppingAddressModel {

  String? name;
  String? country;
  String? city;
  String? state;
  String? street;
  int? postalCode;

  String? email;
  String? phoneNumber;

  ShoppingAddressModel(
      {this.name,
      this.country,
      this.city,
      this.state,
      this.street,
      this.postalCode,
      this.email,
      this.phoneNumber});

  Map<String, dynamic> toMap() => {
        'name': name,
        'country': GetUtils.capitalizeFirst(country!),
        'city': GetUtils.capitalizeFirst(city!),
        'state': GetUtils.capitalizeFirst(state!),
        'street': street,
        'postalCode': postalCode,
        'email': email,
        'phoneNumber': phoneNumber,
      };

  factory ShoppingAddressModel.fromMap(Map<String, dynamic> map) =>
      ShoppingAddressModel(
        name: map['name'],
        country: map['country'],
        city: map['city'],
        state: map['state'],
        street: map['street'],
        postalCode: map['postalCode'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
      );
}
