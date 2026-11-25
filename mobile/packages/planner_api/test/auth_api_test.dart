import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for AuthApi
void main() {
  final instance = PlannerApi().getAuthApi();

  group(AuthApi, () {
    //Future<LoginResponse> apiAuthGooglePost(GoogleLoginRequest googleLoginRequest) async
    test('test apiAuthGooglePost', () async {
      // TODO
    });

    //Future<LoginResponse> apiAuthLoginPost(LoginRequest loginRequest) async
    test('test apiAuthLoginPost', () async {
      // TODO
    });

    //Future<CurrentUserDto> apiAuthMeGet() async
    test('test apiAuthMeGet', () async {
      // TODO
    });

    //Future<LoginResponse> apiAuthRegisterPost(RegisterRequest registerRequest) async
    test('test apiAuthRegisterPost', () async {
      // TODO
    });

  });
}
