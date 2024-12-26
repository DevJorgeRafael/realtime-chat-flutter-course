

import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/home/presentation/pages/group_chat_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/home_page.dart';
import 'package:realtime_chat/apps/home/presentation/pages/personal_chat_page.dart';

class HomeRoutes {
  static final homeRoutes = [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/home/personal-chat',
      builder: (context, state) => const PersonalChatPage(),
    ),
    GoRoute(
      path: '/home/group-chat',
      builder: (context, state) => const GroupChatPage(), 
    )
  ];
}