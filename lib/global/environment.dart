import 'dart:io';

const ip = '192.168.1.7';

class Environment {
  static String apiUrl = Platform.isAndroid ? 'http://$ip:3000/api' : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid ? 'http://$ip:3000' : 'http://localhost:3000';
}