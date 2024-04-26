import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/screens/add_post_screen.dart';
import 'package:CLOSSET/screens/feed_screen.dart';
import 'package:CLOSSET/screens/profile_screen.dart';
import 'package:CLOSSET/screens/search_screen.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    user: User(
      id: 0,
      name: '',
      email: '',
      phone: '',
      gender: '',
      profile_image: '',
      password: '',
    ),

    // uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
