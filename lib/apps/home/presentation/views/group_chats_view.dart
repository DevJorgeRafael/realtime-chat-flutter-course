import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/apps/home/domain/rooms_service.dart';
import 'package:realtime_chat/apps/home/models/rooms_response.dart';
import 'package:realtime_chat/apps/home/presentation/pages/group_chat_page.dart';
import 'package:realtime_chat/helpers/navigation_helper.dart';

class GroupChatsView extends StatefulWidget {
  const GroupChatsView({super.key});

  @override
  State<GroupChatsView> createState() => _GroupChatsViewState();
}

class _GroupChatsViewState extends State<GroupChatsView> {
  final roomsService = RoomsService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _loadRooms,
      header: WaterDropHeader(
        complete: Icon( Icons.check, color: Colors.red[400] ),
        waterDropColor: Colors.red.shade400,
      ),
      child: _listViewRooms(),
    );
  }

  ListView _listViewRooms() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _ , i ) => _roomListTile(rooms[i]),
      separatorBuilder: ( _ , i ) => const Divider(
        // color: Colors.grey,
        height: 8,
      ),
      itemCount: rooms.length
    );
  }

  ListTile _roomListTile(Room room) {
    return ListTile(
      title:
          Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      // subtitle: Text(user.email),
      leading: Stack(children: [
        CircleAvatar(
            radius: 32,
            backgroundColor: Colors.red[300],
            child: const Icon(Icons.group, size: 36))
      ]),
      onTap: () {
        // final chatService = sl<ChatService>();
        // chatService.userReceiver = user;
        NavigationHelper.navigateWithAnimation(
            context, const GroupChatPage(),
            direction: NavigationDirection.right);
      },
    );
  }

  _loadRooms () async {
    rooms = await roomsService.getRooms();

    if ( mounted ) {
      setState(() {});
    }

    _refreshController.refreshCompleted();
  }
}