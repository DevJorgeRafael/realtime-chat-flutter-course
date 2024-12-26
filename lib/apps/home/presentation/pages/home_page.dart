import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/apps/home/presentation/views/group_chats_view.dart';
import 'package:realtime_chat/apps/home/presentation/views/personal_chats_views.dart';
import 'package:realtime_chat/apps/home/widgets/custom_chat_bottom_navigation_bar.dart';
import 'package:realtime_chat/injection_container.dart';
import 'package:realtime_chat/models/user.dart';

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
    final authService = sl<AuthService>();
    final User usuario = authService.user;

    final views = [
      const PersonalChatsView(),
      const GroupChatsView()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Chats' : 'Grupos'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Ícono de menú para abrir el Drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre el Drawer
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(usuario), 
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

  Widget _buildDrawer(User usuario) {
    return Consumer<SocketService>(
      builder: (context, socketService, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      usuario.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          socketService.serverStatus == ServerStatus.online
                              ? 'Online'
                              : 'Offline',
                          style: TextStyle(
                            color: socketService.serverStatus ==
                                    ServerStatus.online
                                ? Colors.green[400]
                                : Colors.red[400],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          color:
                              socketService.serverStatus == ServerStatus.online
                                  ? Colors.green[400]
                                  : Colors.red[400],
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesión'),
                // onTap: () {
                //   socketService.disconnect();
                //   AuthService.logout();
                //   Navigator.pushReplacementNamed(context, '/login');
                // },
              ),
            ],
          ),
        );
      },
    );
  }
}