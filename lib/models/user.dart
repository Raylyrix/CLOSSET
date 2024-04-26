import 'dart:convert';

import 'package:CLOSSET/constants/constants.dart';
import 'package:CLOSSET/models/designer.dart';
import 'package:CLOSSET/models/manufacturer.dart';
import 'package:CLOSSET/models/wishlist.dart';
import 'package:CLOSSET/providers/designer_provider.dart';
import 'package:CLOSSET/providers/manufacturer_provider.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:CLOSSET/providers/wishlists_provider.dart';
import 'package:CLOSSET/responsive/mobile_screen_layout.dart';
import 'package:CLOSSET/responsive/responsive_layout.dart';
import 'package:CLOSSET/responsive/web_screen_layout.dart';
import 'package:CLOSSET/screens/manufacturer_screens/layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String gender;
  String profile_image;
  String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profile_image,
    required this.gender,
    required this.password,
  });

  static Future<void> getUserWithJWT(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Navigator.popAndPushNamed(context, '/login');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${GlobalConstants.backendURL}/user/with_token/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        await setUserAndRelatedData(context, user);
      } else {
        prefs.remove('token');
      }
    } catch (e) {
      // Handle any errors here
      print(e);
    }
  }

  static Future<void> setUserAndRelatedData(
      BuildContext context, User user) async {
    await Provider.of<UserProvider>(context, listen: false).setUser(user);
    bool isAManufacturer = await isManufacturer(context, user.id);
    if (isAManufacturer) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ManufacturerLayout()));
      return;
    }
    await setDesigner(context, user.id);
    await setWishlist(context, user.id);
    navigateToResponsiveLayout(context);
  }

  static Future<bool> isManufacturer(BuildContext context, int userId) async {
    var manufacturer = await Manufacturer.getManufacturerByUserId(userId);
    Provider.of<ManufacturerProvider>(context, listen: false)
        .setManufacturer(manufacturer);

    if (manufacturer.id != 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> setDesigner(BuildContext context, int userId) async {
    var designer = await Designer.getDesignerByUserId(userId);
    await Provider.of<DesignerProvider>(context, listen: false)
        .setDesigner(designer);
  }

  static Future<void> setWishlist(BuildContext context, int userId) async {
    var wishlist = await Wishlist.getWishlists(userId);
    await Provider.of<WishlistsProvider>(context, listen: false)
        .setWishlists(wishlist);
  }

  static void navigateToResponsiveLayout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),
      (route) => false,
    );
  }
  // nameLike := c.Query("name_like")

  static Future<List<User>> searchUsers(String nameLike) async {
    final response = await http.get(
      Uri.parse('${GlobalConstants.backendURL}/user?name_like=$nameLike'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<User> users =
          body.map((dynamic item) => User.fromJson(item)).toList();

      return users;
    } else {
      throw 'Failed to load users';
    }
  }

  static Future<void> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('${GlobalConstants.backendURL}/user/sign_in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonDecode(response.body)['token']);

      // return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in');
    }
  }

// func (router *UserServiceRouter) CreateUser(c *gin.Context) {
// 	var user models.User
// 	form , err := c.MultipartForm()
// 	if err != nil {
// 		c.JSON(400, gin.H{"error": "file too large"})
// 		return
// 	}

// 	image := form.File["profile_image"][0]
// 	if image != nil {
// 		fileHeader := image
// 		f, err := fileHeader.Open()
// 		if err != nil {
// 			c.JSON(400, gin.H{"error": "file too large"})
// 			return
// 		}
// 		defer f.Close()

// 		uploaderURL, err := utils.SaveFile(f, fileHeader)
// 		if err != nil {
// 			c.JSON(500, gin.H{"error": err})
// 			return
// 		}
// 		user.ProfileImage = uploaderURL
// 	}

// 	user.Name = c.PostForm("name")
// 	user.Email = c.PostForm("email")
// 	user.Phone = c.PostForm("phone")
// 	user.Gender = c.PostForm("gender")
// 	user.Password = c.PostForm("password")

// 	c.JSON(200, user)
// }

  static Future<User> registerUser(User user, String profileImgPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest(
        'POST', Uri.parse('${GlobalConstants.backendURL}/user/'));
    profileImgPath != ""
        ? request.files.add(
            await http.MultipartFile.fromPath('profile_image', profileImgPath))
        : null;
    request.fields['name'] = user.name;
    request.fields['email'] = user.email;
    request.fields['phone'] = user.phone;
    request.fields['gender'] = user.gender;
    request.fields['password'] = user.password;

    final req = await request.send();
    final res = await http.Response.fromStream(req);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body)['ID']);
      User user = User(
        id: jsonDecode(res.body)['ID'],
        name: jsonDecode(res.body)['name'],
        email: jsonDecode(res.body)['email'],
        phone: jsonDecode(res.body)['phone'],
        gender: jsonDecode(res.body)['gender'],
        profile_image: jsonDecode(res.body)['profile_image'],
        password: jsonDecode(res.body)['password'],
      );

      await User.signIn(
        user.email,
        user.password,
      );
      return user;
    } else {
      throw Exception('Failed to create user');
    }
  }

  factory User.fromJson(dynamic json) {
    return User(
      id: json['ID'] ?? 0,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      profile_image: json['profile_image'],
      password: json['password'],
    );
  }
}
