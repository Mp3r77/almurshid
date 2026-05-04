import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../constants/endpoints.dart';

abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<void> clearTokens();
}

class SimpleTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }
}

@lazySingleton
class ApiClient {
  late final Dio _dio;
  final TokenStorage? tokenStorage;

  ApiClient({required Dio dio, this.tokenStorage}) {
    _dio = dio;
    _configureBaseOptions();
    _addInterceptors();
  }

  Dio get dio => _dio;

  void _configureBaseOptions() {
    _dio.options = BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    );
  }

  void _addInterceptors() {
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _AuthInterceptor(tokenStorage),
      _ErrorInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      debugPrint('[API] ${options.method} ${options.uri}');
      debugPrint('[API] Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('[API] Body: ${options.data}');
      }
      return true;
    }());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    assert(() {
      debugPrint('[API] ${response.statusCode} ${response.requestOptions.uri}');
      if (response.data != null) {
        debugPrint('[API] Response: ${response.data}');
      }
      return true;
    }());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    assert(() {
      debugPrint('[API] Error: ${err.message}');
      debugPrint('[API] URL: ${err.requestOptions.uri}');
      if (err.response != null) {
        debugPrint('[API] Status: ${err.response?.statusCode}');
        debugPrint('[API] Data: ${err.response?.data}');
      }
      return true;
    }());
    handler.next(err);
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage? _tokenStorage;

  _AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await _tokenStorage?.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final retryResponse = await _retry(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (_) {
        await _tokenStorage?.clearTokens();
      }
    }
    handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    const publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/doctors',
    ];
    return publicEndpoints.any(path.contains);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenStorage?.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final dio = Dio();
      final response = await dio.post<dynamic>(
        '${Endpoints.baseUrl}${Endpoints.refreshToken}',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _tokenStorage?.saveTokens(
          accessToken: data['access_token'] as String,
          refreshToken: data['refresh_token'] as String?,
        );
        return true;
      }
    } catch (error) {
      debugPrint('Token refresh failed: $error');
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions options) async {
    final token = await _tokenStorage?.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';

    final dio = Dio();
    return dio.fetch(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
