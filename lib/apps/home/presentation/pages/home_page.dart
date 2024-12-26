import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/home/presentation/views/group_chats_view.dart';
import 'package:realtime_chat/apps/home/presentation/views/personal_chats_views.dart';
import 'package:realtime_chat/apps/home/widgets/custom_chat_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final views = [
      const PersonalChatsView(),
      const GroupChatsView()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: views,
      ),
      bottomNavigationBar: CustomChatBottomNavigationBar(
        selectedIndex: _selectedIndex, 
        onItemSelected: _onItemSelected
        ),
    );
  }
}