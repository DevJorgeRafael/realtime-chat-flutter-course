 import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtime_chat/config/constants/app_constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseAPIUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json',

      }
    )
  );

  static Dio get instance => _dio;

  static void setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if ( options.path.contains('/auth')) {
          return handler.next(options);
        }

        if ( options.headers.containsKey('x-token')) {
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'token');
          if (token != null) {
            options.headers['x-token'] = token;
          }
        }

        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      }
    ));
  }


 }