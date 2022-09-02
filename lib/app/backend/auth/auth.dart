import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:minima/app/backend/environ.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'user.dart';
import '../../models/auth/auth.dart';

enum SocialLoginStatus { cancelled, success, backendError, socialError }

class Auth {
  static Auth? _instance;
  static Auth get instance => _instance ??= Auth();

  final googleSignIn = GoogleSignIn();
  late Future<void> initialize;
  late SharedPreferences storage;
  bool initialized = false;
  String? token;

  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    initialized = true;
  }

  Auth() {
    initialize = init();
  }

  Future<void> wfi() async {
    if (initialized) return;
    await initialize;
  }

  // 토큰을 가져옵니다.
  Future<String?> getToken() async {
    if (token != null) return token;

    await wfi();

    token = storage.getString('auth.token');

    if (kDebugMode) {
      print('my token: $token');
    }

    return token;
  }

  Future<void> setToken(String token) async {
    await wfi();
    await storage.setString('auth.token', token);
    this.token = token;
  }

  /// 토큰이이 사용가능 상태인지 확인합니다.
  Future<bool> verifyToken() async {
    await wfi();
    final session = await getToken();
    if (session == null) return false;
    final res = await Environ.privateGet(Environ.authServer, '/auth/verify');
    if (kDebugMode) {
      print(res.body);
    }
    return res.statusCode == 200;
  }

  Future<SocialLoginStatus> socialLogin(SocialType type) async {
    await wfi();
    String token;
    try {
      switch (type) {
        case SocialType.kakao:
          kakao.OAuthToken? otoken;
          try {
            if (await kakao.isKakaoTalkInstalled()) {
              otoken = await kakao.UserApi.instance.loginWithKakaoTalk();
            }
          } finally {
            otoken ??= await kakao.UserApi.instance.loginWithKakaoAccount();
          }
          token = otoken.accessToken;
          break;
        case SocialType.google:
          final otoken = await googleSignIn.signIn();
          if (otoken == null) return SocialLoginStatus.cancelled;
          token = (otoken).serverAuthCode!;
          break;
        case SocialType.apple:
          return SocialLoginStatus.socialError;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return SocialLoginStatus.socialError;
    }

    try {
      return await backendSocialLogin(token, type)
          ? SocialLoginStatus.success
          : SocialLoginStatus.backendError;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return SocialLoginStatus.socialError;
    }
  }

  Future<bool> backendSocialLogin(String token, SocialType type) async {
    final res =
        await http.post(Environ.api(Environ.authServer, '/auth/social/login'),
            body: jsonEncode({
              'token': token,
              'type': type.toString().split('.')[1],
            }),
            headers: {
          'Content-Type': 'application/json',
        });

    if (kDebugMode) {
      print(res.body);
    }

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      await setToken(data['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    storage.remove('auth.token');
    User.instance.profile = null;
    token = null;
  }

  Future<bool> sendFeedback(String content) async {
    await wfi();
    return (await Environ.privatePostResopnse(
            Environ.authServer, '/feedback/', (json) => json['success'],
            body: {'feedback': content, 'info': await Environ.getDeviceInfo()},
            jsonencode: false)) ==
        true;
  }
}
