// import 'dart:io';

// const ip = '192.168.205.41';

// class Environment {
//   static String apiUrl = Platform.isAndroid ? 'http://$ip:3000/api' : 'http://localhost:3000/api';
//   static String socketUrl = Platform.isAndroid ? 'http://$ip:3000' : 'http://localhost:3000';
// }

const url = 'https://flutter-basic-chat-server-4d840aa16257.herokuapp.com';

class Environment {
  static String apiUrl = '$url/api';
  static String socketUrl = url;
}