// package models

// type ClothType string

// const (
// 	Shirt ClothType = "shirt"
// 	Pant  ClothType = "pant"
// )

// type ClothMaterial string

// const (
// 	Cotton    ClothMaterial = "cotton"
// 	Polyester ClothMaterial = "polyester"
// )

// type Post struct {
// 	Id           int           `json:"id"`
// 	DesignerID   int           `json:"designer_id"`
// 	ClothType    ClothType     `json:"cloth_type"`
// 	Material     ClothMaterial `json:"material"`
// 	Price        int           `json:"price"`
// 	Image        string        `json:"image"`
// 	LikeCount    uint          `json:"like_count"`
// 	ViewCount    uint          `json:"view_count"`
// 	CommentCount uint          `json:"comment_count"`
// }

// type Like struct {
// 	Id     int `json:"id"`
// 	PostID int `json:"post_id"`
// 	UserID int `json:"user_id"`
// }

// type Comment struct {
// 	Id      int    `json:"id"`
// 	PostID  int    `json:"post_id"`
// 	UserID  int    `json:"user_id"`
// 	Content string `json:"content"`
// }

import 'dart:convert';
import 'dart:developer';

import 'package:CLOSSET/constants/constants.dart';
import 'package:CLOSSET/models/designer.dart';
import 'package:CLOSSET/models/like.dart';
import 'package:CLOSSET/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Post {
  int id;
  int designerID;
  String clothType;
  String material;
  int price;
  DateTime time;
  String image;
  String description;
  int likeCount;
  int viewCount;
  int commentCount;

  Post({
    required this.id,
    required this.designerID,
    required this.clothType,
    required this.material,
    required this.price,
    required this.image,
    required this.time,
    required this.description,
    required this.likeCount,
    required this.viewCount,
    required this.commentCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      designerID: json['designer_id'],
      clothType: json['cloth_type'],
      material: json['material'],
      price: json['price'],
      image: json['image'],
      time: json['time'] != "" ? DateTime.parse(json['time']) : DateTime.now(),
      description: json['description'],
      likeCount: json['like_count'],
      viewCount: json['view_count'],
      commentCount: json['comment_count'],
    );
  }

  static toJson(Post post) {
    return {
      'id': post.id,
      'designer_id': post.designerID,
      'cloth_type': post.clothType,
      'material': post.material,
      'price': post.price,
      'image': post.image,
      'time': post.time.toIso8601String(),
      'description': post.description,
      'like_count': post.likeCount,
      'view_count': post.viewCount,
      'comment_count': post.commentCount,
    };
  }

  static Future<Post> createPost(Post post, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token');
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${GlobalConstants.backendURL}/post/'),
    )
      ..fields['designer_id'] = post.designerID.toString()
      ..fields['cloth_type'] = post.clothType
      ..fields['material'] = post.material
      ..fields['price'] = post.price.toString()
      ..fields['description'] = post.description
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );

    request.headers['Authorization'] = token;

    var req = await request.send();
    var res = await http.Response.fromStream(req);
    if (res.statusCode == 200) {
      return Post.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to create post');
    }
  }
}

// type TotalPost struct {
// 	*models.Post     `json:"post"`
// 	Likes            []models.Like `json:"likes" gorm:"foreignKey:post_id"`
// 	*models.Designer `json:"designer"`
// 	*models.User     `json:"user"`
// }

class TotalPost {
  Post post;
  List<Like> likes;
  Designer designer;
  User user;

  TotalPost({
    required this.post,
    required this.likes,
    required this.designer,
    required this.user,
  });

  static Future<List<TotalPost>> getPosts() async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/post/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      log(body.toString());
      List<TotalPost> posts =
          body.map((dynamic item) => TotalPost.fromJson(item)).toList();
      log(
        posts.toString(),
      );
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  factory TotalPost.fromJson(Map<String, dynamic> json) {
    return TotalPost(
      post: Post.fromJson(json['post']),
      likes: json['likes']
          .map<Like>((dynamic item) => Like.fromJson(item))
          .toList(),
      designer: Designer.fromJson(json['designer']),
      user: User.fromJson(json['user']),
    );
  }
}
