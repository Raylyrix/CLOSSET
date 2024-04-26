// package models

// import "gorm.io/gorm"

// type Designer struct {
// 	Id        uint   `json:"id"`
// 	UserID    uint   `json:"user_id"`
// 	BrandName string `json:"brand_name"`
// }

// type Collaboration struct {
// 	gorm.Model
// 	Name string `json:"name"`
// 	// Designers []Designer `json:"designers"`
// }

// type DesignerCollaboration struct {
// 	Id              int `json:"id"`
// 	DesignerID      int `json:"designer_id"`
// 	CollaborationID int `json:"collaboration_id"`
// }

import 'dart:convert';
import 'dart:developer';

import 'package:CLOSSET/constants/constants.dart';
import 'package:http/http.dart' as http;

class Designer {
  int id;
  int userID;
  String brandName;

  Designer({
    required this.id,
    required this.userID,
    required this.brandName,
  });

  factory Designer.fromJson(Map<String, dynamic> json) {
    return Designer(
      id: json['id'],
      userID: json['user_id'],
      brandName: json['brand_name'],
    );
  }

  static Future<Designer> getDesignerByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/designer?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      log(response.body.toString());
      return Designer.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to load designer';
    }
  }

  static Future<Designer> createDesinger(Designer designer) async {
    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/designer/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(toJson(designer)),
    );

    if (response.statusCode == 200) {
      return Designer.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to create designer';
    }
  }

  static toJson(Designer designer) {
    return {
      'id': designer.id,
      'user_id': designer.userID,
      'brand_name': designer.brandName,
    };
  }

  static Future<List<Designer>> getDesigners() async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}}/designers'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Designer> designers =
          body.map((dynamic item) => Designer.fromJson(item)).toList();

      return designers;
    } else {
      throw 'Failed to load designers';
    }
  }

  // factory
}
