import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio dio;
  final Future<void> Function()? onUnauthorized;

  DioClient(
    String baseUrl, {
    String? token,
    this.onUnauthorized,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token inválido o expirado
            await TokenStorage().clear();
            if (onUnauthorized != null) await onUnauthorized!();
          }
          return handler.next(e);
        },
      ),
    );
  }

  void setToken(String? token) {
    if (token == null) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
