import 'package:flutter/material.dart';

class CustomChatBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomChatBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 1,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (value) {
        onItemSelected(value);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.groups_2), label: "Grupos"),
      ],
    );
  }
}
