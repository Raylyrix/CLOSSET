import 'dart:convert';

import 'package:CLOSSET/constants/constants.dart';
import 'package:http/http.dart' as http;

class Wishlist {
  int id;
  int userId;
  String name;
  List<WishlistItem> wishlistItems;

  Wishlist({
    required this.id,
    required this.userId,
    required this.name,
    required this.wishlistItems,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    List<WishlistItem> wishlistItems = [];
    if (json['wishlist_items'] != null) {
      json['wishlist_items'].forEach((v) {
        wishlistItems.add(WishlistItem.fromJson(v));
      });
    }
    return Wishlist(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      wishlistItems: wishlistItems,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['wishlist_items'] = wishlistItems.map((v) => v.toJson()).toList();
    return data;
  }

  static Future<List<Wishlist>> getWishlists(int userId) async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/wishlist?user_id=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Wishlist> wishlists =
          body.map((dynamic item) => Wishlist.fromJson(item)).toList();
      return wishlists;
    } else {
      throw Exception('Failed to load wishlists');
    }
  }

  static Future<Wishlist> createWishlist(Wishlist wishlist) async {
    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/wishlist/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(wishlist.toJson()),
    );

    if (response.statusCode == 200) {
      return Wishlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create wishlist');
    }
  }

  static Future<Wishlist> updateWishlist(Wishlist wishlist) async {
    final response = await http.put(
      Uri.parse('${GlobalConstants.backendURL}/wishlist/${wishlist.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(wishlist.toJson()),
    );

    if (response.statusCode == 200) {
      return Wishlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update wishlist');
    }
  }

  static Future<void> deleteWishlist(int id) async {
    final response = await http.delete(
      Uri.parse('${GlobalConstants.backendURL}/wishlist/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete wishlist');
    }
  }
}

class WishlistItem {
  int id;
  int wishlistId;
  int postId;

  WishlistItem({
    required this.id,
    required this.wishlistId,
    required this.postId,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      wishlistId: json['wishlist_id'],
      postId: json['post_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wishlist_id'] = wishlistId;
    data['post_id'] = postId;
    return data;
  }
}
