import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/group_chat_page.dart';
import 'package:realtime_chat/apps/chat/presentation/pages/personal_chat_page.dart';

class ChatRoutes {
  static final homeRoutes = [
    GoRoute(
      path: '/chat/personal-chat',
      builder: (context, state) => const PersonalChatPage(),
    ),
    GoRoute(
      path: '/chat/group-chat',
      builder: (context, state) => const GroupChatPage(),
    )
  ];
}
