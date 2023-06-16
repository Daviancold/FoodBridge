import 'package:flutter/material.dart';
import 'package:foodbridge_project/widgets/chat_widgets/chat_list.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: const AllChatList(),
    );
  }
}
