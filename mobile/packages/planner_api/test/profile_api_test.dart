import 'package:test/test.dart';
import 'package:planner_api/planner_api.dart';


/// tests for ProfileApi
void main() {
  final instance = PlannerApi().getProfileApi();

  group(ProfileApi, () {
    //Future<AvatarDto> apiProfileAvatarDelete() async
    test('test apiProfileAvatarDelete', () async {
      // TODO
    });

    //Future<AvatarDto> apiProfileAvatarPut({ MultipartFile file }) async
    test('test apiProfileAvatarPut', () async {
      // TODO
    });

    //Future<CurrentUserDto> apiProfilePatch(UpdateProfileRequest updateProfileRequest) async
    test('test apiProfilePatch', () async {
      // TODO
    });

  });
}
