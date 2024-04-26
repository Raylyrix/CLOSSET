import 'package:CLOSSET/screens/manufacturer_screens/account_page.dart';
import 'package:CLOSSET/screens/manufacturer_screens/homepage.dart';
import 'package:flutter/material.dart';

class ManufacturerLayout extends StatefulWidget {
  const ManufacturerLayout({Key? key}) : super(key: key);

  @override
  State<ManufacturerLayout> createState() => _ManufacturerLayoutState();
}

class _ManufacturerLayoutState extends State<ManufacturerLayout> {
  final pages = [
    const HomePage(),
    const AccountPage(),
  ];
  @override
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
          colorScheme: const ColorScheme.light(primary: Colors.blue)),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: pages[_selectedIndex],
      ),
    );
  }
}
