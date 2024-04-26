import 'package:CLOSSET/providers/designer_provider.dart';
import 'package:CLOSSET/providers/manufacturer_provider.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:CLOSSET/providers/wishlists_provider.dart';
import 'package:CLOSSET/screens/login_screen.dart';
import 'package:CLOSSET/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DesignerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ManufacturerProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: Rout
          initialRoute: '/mf',
          routes: {
            '/': (context) => const LoginScreen(),
            // '/mf': (context) => const ManufacturerRegistration()
          }),
    );
  }
}
