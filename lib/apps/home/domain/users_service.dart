import 'package:flutter/material.dart';
import 'package:realtime_chat/config/constants/app_constants.dart';

import 'package:realtime_chat/shared/models/user.dart';
import 'package:realtime_chat/apps/home/models/users_response.dart';

import 'package:realtime_chat/shared/service/dio_client.dart';

class UsersService with ChangeNotifier{
  final String url = AppConstants.baseAPIUrl;

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