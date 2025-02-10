import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/apps/home/models/users_response.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';

class UsersService extends SafeChangeNotifier{

  Future<List<User>> getUsers () async {
    // try {
    //   final response = await DioClient.instance.get('/users');
    //   final usersResponse = UsersResponse.fromList(response.data);
    //   return usersResponse.users;
    // } catch (e) {
    //   print('Error al obtener usuarios: \n $e');
    //   return [];
    // }

    final mockData = [
      {
        "name": "Juan",
        "email": "test2@test.com",
        "online": false,
        "id": "676a507276382119e5b0e7e9"
      },
      {
        "name": "Carlos",
        "email": "test3@test.com",
        "online": false,
        "id": "676a5117dda428f24c12249c"
      },
      {
        "name": "Carlos",
        "email": "test4@test.com",
        "online": false,
        "id": "676a51ae625dc992ab2c1d11"
      },
      {
        "name": "Carlos",
        "email": "test5@test.com",
        "online": false,
        "id": "676a51e768258328264c624e"
      },
      {
        "name": "Carlos",
        "email": "test6@test.com",
        "online": false,
        "id": "676a52a9f52bb614c936692d"
      },
      {
        "name": "Ricardo",
        "email": "test8@test.com",
        "online": false,
        "id": "676f6322794f7c7be5c2d46d"
      },
      {
        "name": "Ricardo",
        "email": "test9@test.com",
        "online": false,
        "id": "676f6386794f7c7be5c2d471"
      }
    ];

    // Convertir los datos mock a una lista de objetos `User`
    final users = mockData.map((data) => User.fromJson(data)).toList();
    return users;
  }
}