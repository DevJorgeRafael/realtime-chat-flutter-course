import 'package:realtime_chat/apps/chat/models/rooms_response.dart';
import 'package:realtime_chat/shared/service/dio_client.dart';
import 'package:realtime_chat/shared/utils/safe_change_notifier.dart';

class RoomsService extends SafeChangeNotifier {
  Future<List<Room>> getRooms() async {
    try {
      final response = await DioClient.instance.get('/rooms');
      final roomsResponse = roomsResponseFromJson(response.data);
      return roomsResponse;
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<Room?> getRoomById(String roomId) async {
    try {
      // Realiza la solicitud GET a un endpoint específico de room
      final response = await DioClient.instance.get('/rooms/$roomId');
      // Convierte la respuesta JSON en un objeto Room
      final room = Room.fromJson(response.data);
      return room;
    } catch (e) {
      print('Error fetching room by ID: $e');
      return null;
    }
  }

  Future<bool> createRoom(String name, List<String> memberIds) async {
    try {
      // Realiza la solicitud POST para crear una nueva sala
      final response = await DioClient.instance.post(
        '/rooms',
        data: {
          "name": name,
          "members": memberIds, // Lista de IDs de los miembros
        },
      );
      return response.statusCode ==
          201; // Devuelve true si la creación fue exitosa
    } catch (e) {
      print('Error creating room: $e');
      return false;
    }
  }

  Future<bool> deleteRoom(String roomId) async {
    try {
      // Realiza la solicitud DELETE para eliminar una sala
      final response = await DioClient.instance.delete('/rooms/$roomId');
      return response.statusCode ==
          200; // Devuelve true si la eliminación fue exitosa
    } catch (e) {
      print('Error deleting room: $e');
      return false;
    }
  }
}