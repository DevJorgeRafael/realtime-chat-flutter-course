import 'package:go_router/go_router.dart';
import 'package:realtime_chat/apps/home/presentation/pages/home_page.dart';

class HomeRoutes {
  static final homeRoutes = [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    )
  ];
}