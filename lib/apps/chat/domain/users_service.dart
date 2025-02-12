import 'package:realtime_chat/apps/chat/models/users_response.dart';
import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';

class UsersService extends SafeChangeNotifier{

  Future<List<User>> getUsers () async {
    try {
      final response = await DioClient.instance.get('/users');
      final usersResponse = UsersResponse.fromList(response.data);
      return usersResponse.users;
    } catch (e) {
      print('Error al obtener usuarios: \n $e');
      return [];
    }
  }
}