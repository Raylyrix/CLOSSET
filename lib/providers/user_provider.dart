import 'package:CLOSSET/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: 0,
    name: '',
    email: '',
    phone: '',
    profile_image: '',
    gender: '',
    password: '',
  );

  User get user => _user;

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }
}
