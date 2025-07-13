import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  ApiService._internal() {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static final ApiService instance = ApiService._internal();

  late final Dio _dio;
  static const _baseUrl = 'https://your-server-url/api';
  final _storage = const FlutterSecureStorage();

  Dio get client => _dio;
}