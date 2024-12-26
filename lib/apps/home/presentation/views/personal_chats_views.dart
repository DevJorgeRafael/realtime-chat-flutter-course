import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/socket_service.dart';
import 'package:realtime_chat/apps/home/domain/users_service.dart';
import 'package:realtime_chat/injection_container.dart';

import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/apps/home/presentation/pages/personal_chat_page.dart';



class PersonalChatsView extends StatefulWidget {
  const PersonalChatsView({super.key});
  @override
  State<PersonalChatsView> createState() => _PersonalChatsViewState();
}

class _PersonalChatsViewState extends State<PersonalChatsView> {

  final usersService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = sl<AuthService>();
    final socketService = sl<SocketService>();
    final usuario = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario.name ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app_outlined ),
          onPressed: () {
            socketService.disconnect();
            context.go('/login');
            AuthService.logout();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10),
            child: socketService.serverStatus == ServerStatus.online ? 
            Icon( Icons.circle, color: Colors.green[400], )
            : Icon( Icons.circle, color: Colors.red[500], ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue.shade400,
        ),
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _ , i ) => _usuarioListTile(users[i]) , 
      separatorBuilder: ( _ , i ) => const Divider(),
      itemCount: users.length
    );
  }

  ListTile _usuarioListTile(User user) {
    return ListTile(
        title: Text( user.name, style: const TextStyle(fontWeight: FontWeight.bold) ),
        subtitle: Text( user.email ),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[100],
              child: const Icon( Icons.person_sharp )
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user.online? Colors.green[400] : Colors.red[400],
                  border: Border.all(width: 1.5, color: Colors.white)
                ),
              )
            )
          ]
        ),
        onTap: () {
          final chatService = sl<ChatService>();
          chatService.usuarioPara = user;
          Navigator.push(
            context, 
            PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // Definir la página a la que quieres navegar
              return PersonalChatPage(); 
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0); 

              var end = Offset.zero;
              var curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
          );
        },
      );
  }

  _cargarUsuarios () async {

    users = await usersService.getUsers();
    if ( mounted ) {
      setState(() => {});
    }

    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}