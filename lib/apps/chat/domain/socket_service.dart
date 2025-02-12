import 'package:realtime_chat/config/constants/app_constants.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService extends SafeChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {

    final token = await AuthService.getToken();
    // Io client
    _socket = io.io( AppConstants.baseSocketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
    _serverStatus = ServerStatus.connecting;
    notifyListeners();
  }
}
