import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/pages/chat_page.dart';
import 'package:realtime_chat/services/services.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = UsuariosService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text( usuario.nombre ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app_outlined ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
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
      itemBuilder: ( _ , i ) => _usuarioListTile(usuarios[i]) , 
      separatorBuilder: ( _ , i ) => const Divider(),
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text( usuario.nombre, style: const TextStyle(fontWeight: FontWeight.bold) ),
        subtitle: Text( usuario.email ),
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
                  color: usuario.online? Colors.green[400] : Colors.red[400],
                  border: Border.all(width: 1.5, color: Colors.white)
                ),
              )
            )
          ]
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.push(
            context, 
            PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              // Definir la página a la que quieres navegar
              return ChatPage(); 
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

    usuarios = await usuarioService.getUsuarios();
    if ( mounted ) {
      setState(() => {});
    }

    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}