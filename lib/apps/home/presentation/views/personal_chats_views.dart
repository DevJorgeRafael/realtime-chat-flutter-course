import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/apps/home/domain/chat_service.dart';
import 'package:realtime_chat/apps/home/domain/users_service.dart';
import 'package:realtime_chat/helpers/navigation_helper.dart';
import 'package:realtime_chat/injection_container.dart';

import 'package:realtime_chat/shared/models/user.dart';
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
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _cargarUsuarios,
      header: WaterDropHeader(
        complete: Icon( Icons.check, color: Colors.blue[400] ),
        waterDropColor: Colors.blue.shade400,
      ),
      child: _listViewUsuarios(),
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
              backgroundColor: Colors.red[300],
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
          NavigationHelper.navigateWithAnimation(
            context,
            const PersonalChatPage(),
            direction: NavigationDirection.right
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