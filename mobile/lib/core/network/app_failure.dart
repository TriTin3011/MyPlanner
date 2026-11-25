import 'package:dio/dio.dart';

/// Lỗi đã được phân loại để UI chọn câu thông báo, thay vì in nguyên `DioException`.
///
/// `sealed` để `switch` trên UI phải xử lý đủ mọi loại (trình biên dịch kiểm).
sealed class AppFailure implements Exception {
  const AppFailure();

  /// Chuyển mọi lỗi (DioException, FormatException…) về một `AppFailure`.
  static AppFailure from(Object error) {
    if (error is AppFailure) return error;
    if (error is DioException) return _fromDio(error);
    return UnknownFailure(error.toString());
  }

  static AppFailure _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.cancel:
        return const CancelledFailure();
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return e.error is Exception && e.response == null
            ? const NetworkFailure()
            : UnknownFailure(e.message ?? '');
      case DioExceptionType.badResponse:
        break;
    }

    final response = e.response;
    final status = response?.statusCode ?? 0;
    final problem = Problem.tryParse(response?.data);

    if (status == 401) return UnauthorizedFailure(problem?.message);
    if (status == 429) {
      final header = response?.headers.value('retry-after');
      return TooManyRequestsFailure(int.tryParse(header ?? '') ?? 60);
    }
    if (status == 400 && problem?.errors.isNotEmpty == true) {
      return ValidationFailure(problem!.message, problem.errors);
    }
    return ApiFailure(status, problem?.message);
  }
}

class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

class CancelledFailure extends AppFailure {
  const CancelledFailure();
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([this.message]);

  /// Câu của backend (ví dụ "Sai tên đăng nhập hoặc mật khẩu" ở màn đăng nhập).
  final String? message;
}

class TooManyRequestsFailure extends AppFailure {
  const TooManyRequestsFailure(this.retryAfterSeconds);
  final int retryAfterSeconds;
}

/// 400 kèm `errors` theo từng trường (ValidationProblemDetails của ASP.NET).
class ValidationFailure extends AppFailure {
  const ValidationFailure(this.message, this.fieldErrors);
  final String? message;
  final Map<String, List<String>> fieldErrors;

  /// Lỗi đầu tiên, đủ cho form nhỏ trên điện thoại.
  String? get firstError =>
      fieldErrors.values.expand((e) => e).firstOrNull ?? message;
}

/// Lỗi có mã HTTP khác (404, 409, 500…), `message` lấy từ ProblemDetails nếu có.
class ApiFailure extends AppFailure {
  const ApiFailure(this.status, this.message);
  final int status;
  final String? message;
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(this.detail);
  final String detail;
}

/// ProblemDetails (RFC 9457) đọc thẳng từ JSON, không phụ thuộc client sinh ra.
class Problem {
  const Problem({this.title, this.detail, this.errors = const {}});

  final String? title;
  final String? detail;
  final Map<String, List<String>> errors;

  /// `detail` cụ thể hơn `title` nên ưu tiên. Backend đã dịch theo `Accept-Language`.
  String? get message => (detail?.isNotEmpty == true) ? detail : title;

  static Problem? tryParse(Object? data) {
    if (data is! Map) return null;
    final errors = <String, List<String>>{};
    final raw = data['errors'];
    if (raw is Map) {
      raw.forEach((key, value) {
        if (value is List) errors['$key'] = value.map((v) => '$v').toList();
      });
    }
    return Problem(
      title: data['title'] as String?,
      detail: data['detail'] as String?,
      errors: errors,
    );
  }
}
