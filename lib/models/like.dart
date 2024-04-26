// type Like struct {
// 	Id     int `json:"id"`
// 	PostID int `json:"post_id"`
// 	UserID int `json:"user_id"`
// }

import 'dart:convert';

import 'package:CLOSSET/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Like {
  int id;
  int postID;
  int userID;

  Like({
    required this.id,
    required this.postID,
    required this.userID,
  });

  static Future<Like> likeAPost(int postID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/post/like/$postID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      return Like.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create like');
    }
  }

  static disLike(int postID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${GlobalConstants.backendURL}/post/like/$postID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete like');
    }
  }

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      postID: json['post_id'],
      userID: json['user_id'],
    );
  }
}
