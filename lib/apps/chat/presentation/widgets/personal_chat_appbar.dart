import 'package:flutter/material.dart';
import 'package:realtime_chat/apps/chat/domain/call_service.dart';
import 'package:realtime_chat/shared/models/user.dart';

class PersonalChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  const PersonalChatAppbar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final callService = CallService();
    final userReceiver = user;

    return AppBar(
      backgroundColor: Colors.red,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 1,
      titleSpacing: 0, // Elimina espacios innecesarios
      title: InkWell(
        onTap: () {
          // 🚀 Aquí puedes abrir el perfil del usuario
          print("Abrir perfil de ${user.name}");
        },
        child: Row(
          children: [
            const SizedBox(width: 5),
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(Icons.account_circle, size: 40, color: Colors.red),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Evita que ocupe más espacio del necesario
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.circle,
                        color: user.online ? Colors.green : Colors.grey,
                        size: 10), // 🔹 Tamaño más pequeño para un mejor ajuste
                    const SizedBox(width: 5),
                    Text(
                      user.online ? 'En línea' : 'Desconectado',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          onPressed: () {
            callService.startCall(userReceiver.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // 🚀 Aquí puedes abrir la funcionalidad de búsqueda en el chat
            print("Abrir búsqueda en el chat");
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            switch (value) {
              case 'info':
                break;
              case 'mute':
                break;
              case 'clear':
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
                value: 'info', child: Text('Información del contacto')),
            const PopupMenuItem(
                value: 'mute', child: Text('Silenciar notificaciones')),
            const PopupMenuItem(value: 'clear', child: Text('Limpiar chat')),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
