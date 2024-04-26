import 'dart:convert';

import 'package:CLOSSET/constants/constants.dart';
import 'package:http/http.dart' as http;

class Manufacturer {
  int id;
  int userId;
  String certification;
  String bankAccount;
  int capacity;
  String clothTypes;
  String materialTypes;

  Manufacturer({
    required this.id,
    required this.userId,
    required this.certification,
    required this.bankAccount,
    required this.capacity,
    required this.clothTypes,
    required this.materialTypes,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['ID'],
      userId: json['user_id'],
      certification: json['certification'],
      bankAccount: json['bank_account'],
      capacity: json['capacity'],
      clothTypes: json['cloth_types'],
      materialTypes: json['material_types'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'certification': certification,
      'bank_account': bankAccount,
      'capacity': capacity,
      'cloth_types': clothTypes,
      'material_types': materialTypes,
    };
  }

  static Future<Manufacturer> getManufacturerByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/manufacturer?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      return Manufacturer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load manufacturer');
    }
  }

  static Future<Manufacturer> createManufacturer(
      Manufacturer manufacturer) async {
    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/manufacturer/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(manufacturer.toJson()),
    );

    if (response.statusCode == 200) {
      return Manufacturer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create manufacturer');
    }
  }
}
