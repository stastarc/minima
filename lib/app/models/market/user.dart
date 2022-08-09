class UserInfo {
  final int id;
  final String nickname;
  final String? picture;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.picture,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'],
        picture = json['picture'];
}
