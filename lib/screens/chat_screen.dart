import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class Basic extends StatefulWidget {
  const Basic({Key? key}) : super(key: key);

  @override
  _BasicState createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  List<ChatMessage> messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Basic example'),
        ),
        body: DashChat(
          currentUser: user,
          onSend: (ChatMessage m) {
            setState(() {
              messages.insert(0, m);
            });
          },
          messages: messages,
        ),
      ),
    );
  }
}
