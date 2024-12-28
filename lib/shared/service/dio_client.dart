 import 'package:dio/dio.dart';
import 'package:realtime_chat/apps/auth/domain/auth_service.dart';
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

        if ( !options.headers.containsKey('x-token')) {
          options.headers['x-token'] = await AuthService.getToken();
        }

        return handler.next(options);
      },
      onError: (error, handler) {
        if ( error.response?.statusCode == 401 ) {
          AuthService.deleteToken();
          AuthService.logout();
        }

        return handler.next(error);
      }
    ));
  }


 }