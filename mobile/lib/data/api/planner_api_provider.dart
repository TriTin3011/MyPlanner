import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_api/planner_api.dart';

import '../../core/network/dio_provider.dart';

/// Client sinh từ OpenAPI, dùng chung một Dio (đã gắn Bearer + Accept-Language).
/// `interceptors: const []` để client sinh ra không tự gắn interceptor auth mặc định
/// của nó: việc đó đã do `PlannerInterceptor` lo.
final plannerApiProvider = Provider<PlannerApi>(
  (ref) => PlannerApi(dio: ref.watch(dioProvider), interceptors: const []),
);

extension ResponseDataX<T> on Future<Response<T>> {
  /// Lấy body; backend luôn trả body cho 200/201 nên null nghĩa là hợp đồng bị vỡ.
  Future<T> body() async {
    final res = await this;
    final data = res.data;
    if (data == null) throw StateError('Empty response body: ${res.requestOptions.path}');
    return data;
  }
}
