import 'package:dio/dio.dart' show MultipartFile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_api/planner_api.dart' as api;

import '../../domain/models/habit_item.dart';
import '../../domain/models/session.dart';
import '../api/planner_api_provider.dart';
import '../mappers/mappers.dart';

/// Đăng nhập / đăng ký / Google / hồ sơ. Trả `Session` (model domain), không trả DTO.
class AuthRepository {
  AuthRepository(this._api);
  final api.PlannerApi _api;

  api.AuthApi get _auth => _api.getAuthApi();

  Session _toSession(api.LoginResponse r) => Session(
        accessToken: r.accessToken,
        expiresAt: r.expiresAt,
        userName: r.userName,
        displayName: r.displayName,
      );

  Future<Session> login(String userName, String password) async => _toSession(
        await _auth
            .apiAuthLoginPost(loginRequest: api.LoginRequest(userName: userName.trim(), password: password))
            .body(),
      );

  Future<Session> register(String userName, String password) async => _toSession(
        await _auth
            .apiAuthRegisterPost(
                registerRequest: api.RegisterRequest(userName: userName.trim(), password: password))
            .body(),
      );

  Future<Session> google(String idToken) async => _toSession(
        await _auth.apiAuthGooglePost(googleLoginRequest: api.GoogleLoginRequest(idToken: idToken)).body(),
      );

  Future<UserProfile> me() async => (await _auth.apiAuthMeGet().body()).toModel();

  Future<UserProfile> updateDisplayName(String? displayName) async {
    final trimmed = displayName?.trim();
    return (await _api
            .getProfileApi()
            .apiProfilePatch(
                updateProfileRequest:
                    api.UpdateProfileRequest(displayName: (trimmed == null || trimmed.isEmpty) ? null : trimmed))
            .body())
        .toModel();
  }

  /// Trả presigned URL (sống 1 giờ) của ảnh mới.
  Future<String?> uploadAvatar(String filePath) async {
    final file = await MultipartFile.fromFile(filePath);
    return (await _api.getProfileApi().apiProfileAvatarPut(file: file).body()).avatarUrl;
  }

  Future<void> deleteAvatar() => _api.getProfileApi().apiProfileAvatarDelete();
}

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(plannerApiProvider)));
