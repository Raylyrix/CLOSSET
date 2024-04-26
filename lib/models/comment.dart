// type Comment struct {
// 	Id      int    `json:"id"`
// 	PostID  int    `json:"post_id"`
// 	UserID  int    `json:"user_id"`
// 	Content string `json:"content"`
// }

import 'dart:convert';

import 'package:CLOSSET/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// type Comment struct {
// 	Id     int `json:"id"`
// 	PostID int `json:"post_id"`
// 	UserID    int    `json:"user_id"`
// 	UserName  string `json:"user_name"`
// 	UserImage string `json:"user_image"`
// 	Content   string `json:"content"`
// }

class Comment {
  int id;
  int postID;
  int userID;
  String userName;
  String userImage;
  String content;

  Comment({
    required this.id,
    required this.postID,
    required this.userID,
    required this.userName,
    required this.userImage,
    required this.content,
  });
  // router.POST("/comment/:id", s.CommentPost)

  static Future<Comment> createComment(Comment comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/post/comment/${comment.postID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token!,
      },
      body: jsonEncode(<String, String>{
        'content': comment.content,
        'user_id': comment.userID.toString(),
        'user_name': comment.userName,
        'user_image': comment.userImage,
        'post_id': comment.postID.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  static Future<List<Comment>> getComments(int postID) async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/post/comment/$postID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Comment> comments =
          body.map((dynamic item) => Comment.fromJson(item)).toList();

      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postID: json['post_id'],
      userID: json['user_id'],
      userName: json['user_name'],
      userImage: json['user_image'],
      content: json['content'],
    );
  }
}
