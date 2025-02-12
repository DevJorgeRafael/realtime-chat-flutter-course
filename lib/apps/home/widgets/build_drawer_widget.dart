import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/chat/domain/socket_service.dart';
import 'package:realtime_chat/shared/models/user.dart';
import 'package:go_router/go_router.dart';

Widget buildDrawerWidget(User usuario) {
  return Consumer<SocketService>(
    builder: (context, socketService, child) {
      return Drawer(
        child: Column(
          children: [
            _buildUserHeader(usuario, socketService),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.settings, "Configuración", () {
                    context.pop();
                    context.go('/settings');
                  }),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildLogoutTile(context, socketService),
          ],
        ),
      );
    },
  );
}

Widget _buildUserHeader(User usuario, SocketService socketService) {
  return UserAccountsDrawerHeader(
    decoration: const BoxDecoration(color: Colors.red),
    accountName: Text(
      usuario.name,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    accountEmail: Text(usuario.email),
    currentAccountPicture: const CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 50, color: Colors.red),
    ),
    otherAccountsPictures: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle,
              color: socketService.serverStatus == ServerStatus.online
                  ? Colors.green
                  : Colors.grey,
              size: 12), // 🔥 Icono más pequeño
          const SizedBox(height: 2),
          Text(
            socketService.serverStatus == ServerStatus.online
                ? 'Online'
                : 'Offline',
            style: const TextStyle(
                fontSize: 10, color: Colors.white70), 
          ),
        ],
      ),
    ],
  );
}


Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.black54),
    title: Text(title),
    onTap: onTap,
  );
}

Widget _buildConnectionStatus(SocketService socketService) {
  bool isOnline = socketService.serverStatus == ServerStatus.online;
  return ListTile(
    leading: Icon(
      Icons.circle,
      color: isOnline ? Colors.green : Colors.grey,
    ),
    title: Text(
      isOnline ? 'Online' : 'Offline',
      style: const TextStyle(color: Colors.black54),
    ),
  );
}

Widget _buildLogoutTile(BuildContext context, SocketService socketService) {
  return ListTile(
    leading: const Icon(Icons.logout, color: Colors.red),
    title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
    onTap: () {
      socketService.disconnect();
      AuthService.logout();
      context.go('/login');
    },
  );
}
