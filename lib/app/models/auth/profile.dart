import 'package:minima/app/models/auth/auth.dart';

class ProfileData {
  final int id;
  String nickname;
  String? picture;
  final SocialType socialType;
  final String email;
  final UserStatus status;
  final DateTime createdAt;

  ProfileData({
    required this.id,
    required this.nickname,
    required this.picture,
    required this.socialType,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final socialType = json['social_type'] as String;
    final status = json['status'];
    return ProfileData(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      picture: json['picture'] as String?,
      socialType: SocialType.values.firstWhere(
        (type) => type.toString().contains(socialType),
      ),
      email: json['email'] as String,
      status:
          UserStatus.values.firstWhere((e) => e.toString().contains(status)),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
