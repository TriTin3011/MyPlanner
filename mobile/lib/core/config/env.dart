/// Cấu hình đọc lúc build qua `--dart-define` (hoặc `--dart-define-from-file`).
///
/// Giá trị mặc định dành cho máy ảo Android: `10.0.2.2` là địa chỉ mà máy ảo
/// dùng để gọi `localhost` của máy tính đang chạy backend.
class Env {
  const Env._();

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:5274',
  );

  /// Client ID loại "Web application" trên Google Cloud, dùng làm
  /// `serverClientId` để Google trả về idToken mà backend kiểm được.
  static const googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');

  /// `dev` hoặc `prod`, chỉ để hiển thị và chọn hành vi nhỏ (ví dụ log).
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static bool get isProd => flavor == 'prod';
}
