import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../session/session_controller.dart';
import '../settings/app_settings.dart';

/// Gắn token, ngôn ngữ và bắt 401 cho mọi request.
///
/// Tương đương `axios.interceptors` bên web và `DelegatingHandler` bên WPF:
/// một chỗ duy nhất lo phần "xuyên suốt", repository không phải nhớ.
class PlannerInterceptor extends Interceptor {
  PlannerInterceptor({
    required this.token,
    required this.language,
    required this.onUnauthorized,
  });

  final String? Function() token;
  final String Function() language;
  final void Function() onUnauthorized;

  /// Các endpoint mà 401 nghĩa là "sai mật khẩu", không phải "phiên hết hạn".
  static const _authPaths = ['/api/auth/login', '/api/auth/register', '/api/auth/google'];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final t = token();
    if (t != null) options.headers['Authorization'] = 'Bearer $t';
    options.headers['Accept-Language'] = language();
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path = err.requestOptions.path;
    if (err.response?.statusCode == 401 && !_authPaths.any(path.endsWith)) {
      onUnauthorized();
    }
    handler.next(err);
  }
}

Dio createDio({
  required String baseUrl,
  required PlannerInterceptor interceptor,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  ));
  dio.interceptors.add(interceptor);
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestHeader: false, responseBody: false, logPrint: (o) => debugPrint('$o')));
  }
  return dio;
}

final apiBaseUrlProvider = Provider<String>((ref) => Env.apiUrl);

final dioProvider = Provider<Dio>((ref) {
  final dio = createDio(
    baseUrl: ref.watch(apiBaseUrlProvider),
    interceptor: PlannerInterceptor(
      token: () => ref.read(sessionProvider.notifier).validToken,
      language: () => ref.read(settingsProvider).language,
      onUnauthorized: () => ref.read(sessionProvider.notifier).expire(),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
