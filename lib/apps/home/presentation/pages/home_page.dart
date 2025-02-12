import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/presentation/views/group_chats_view.dart';
import 'package:realtime_chat/apps/home/presentation/views/personal_chats_view.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/apps/home/widgets/build_drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = sl<AuthService>();
    final User usuario = authService.user;

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: buildDrawerWidget(usuario),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          PersonalChatsView(),
          GroupChatsView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton:
          _selectedIndex == 1 ? _buildFloatingActionButton() : null,
    );
  }

  /// **🔹 AppBar con título dinámico y botón de búsqueda**
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_selectedIndex == 0 ? 'Chats' : 'Grupos'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implementar búsqueda
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  /// **🔹 Barra de navegación inferior**
  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onNavBarTapped,
      elevation: 5,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.chat),
          selectedIcon: Icon(Icons.chat, color: Colors.red),
          label: 'Chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.group),
          selectedIcon: Icon(Icons.group, color: Colors.red),
          label: 'Grupos',
        ),
      ],
      backgroundColor: Colors.white,
      indicatorColor: Colors.red.withOpacity(0.1),
      surfaceTintColor: Colors.white,
    );
  }

  /// **🔹 Floating Action Button para Grupos**
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Acción para crear grupo
      },
      backgroundColor: Colors.red[400],
      child: const Icon(Icons.group_add),
    );
  }
}
