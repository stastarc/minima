import 'package:minima/app/backend/environ.dart';
import 'package:minima/app/models/auth/profile.dart';

enum SocialLoginStatus { cancelled, success, backendError, socialError }

class User {
  static User? _instance;
  static User get instance => _instance ??= User();
  ProfileData? profile;

  Future<ProfileData?> getInfo({int userId = 0}) async {
    return await Environ.privateGetResopnse(Environ.authServer,
        'user/info/$userId', (json) => ProfileData.fromJson(json['profile']));
  }

  Future<ProfileData?> getMyCached() async {
    if (profile != null) return profile;
    final my = await getInfo(userId: 0);
    if (my == null) return null;
    return profile = my;
  }
}
