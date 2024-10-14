import 'package:flutter/material.dart';
import 'package:realtime_chat/models/usuario.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarios = [
    Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Nombre'),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app_outlined ),
          onPressed: () {
            
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10),
            child: Icon( Icons.circle, color: Colors.green[500], ),
            // child: Icon( Icons.circle, color: Colors.red[500], ),
          )
        ],
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: ( _ , i ) => _usuarioListTile(usuarios[i]) , 
        separatorBuilder: ( _ , i ) => Divider(),
        itemCount: usuarios.length
      )
   );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text( usuario.nombre ),
        subtitle: Text( usuario.email ),
        leading: CircleAvatar(
          backgroundColor: Colors.red[100],
          child: Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: usuario.online? Colors.green[400] : Colors.red[400],
          ),
        ),
      );
  }
}