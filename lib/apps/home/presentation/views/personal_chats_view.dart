import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:realtime_chat/apps/chat/domain/chat_service.dart';
import 'package:realtime_chat/apps/chat/domain/users_service.dart';
import 'package:realtime_chat/helpers/navigation_helper.dart';
import 'package:realtime_chat/injection_container.dart';

import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/personal_chat_page.dart';

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
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _loadUsers,
      header: WaterDropHeader(
        complete: Icon( Icons.check, color: Colors.red[400] ),
        waterDropColor: Colors.red.shade400,
      ),
      child: _listViewUsers(),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _ , i ) => _userListTile(users[i]), 
      separatorBuilder: ( _ , i ) => const Divider(
        // color: Colors.grey,
        height: 8,
      ),
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text( user.name, style: const TextStyle(fontWeight: FontWeight.bold) ),
        subtitle: Text( user.email ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.red[300],
              child: const Icon( Icons.person_sharp, size: 36 )
            ),
            Positioned(
              right: 5,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
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
          chatService.userReceiver = user;
          NavigationHelper.navigateWithAnimation(
            context,
            const PersonalChatPage(),
            direction: NavigationDirection.right
          );
        },
      );
  }

  _loadUsers () async {
    users = await usersService.getUsers();
    if ( mounted ) {
      setState(() => {});
    }

    _refreshController.refreshCompleted();
  }
}