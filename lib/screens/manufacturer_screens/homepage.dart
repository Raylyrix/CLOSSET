import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            title: const Text('Orders'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Incoming Orders'),
                Tab(text: 'Previous Orders'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: Text('Incoming Orders'),
              ),
              Center(
                child: Text('Previous Orders'),
              ),
            ],
          ),
        ));
  }
}
