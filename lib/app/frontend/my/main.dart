import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/auth.dart';
import 'package:minima/app/backend/auth/user.dart';
import 'package:minima/app/frontend/my/widgets/card_item.dart';
import 'package:minima/app/frontend/my/widgets/profile_picture.dart';
import 'package:minima/app/models/auth/profile.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:minima/shared/widgets/retry.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<void> initialized;
  dynamic profile;

  Future<void> initialize() async {
    try {
      profile = await User.instance.getMyCached();
    } catch (e) {
      profile = BackendError.fromException(e);
    }
  }

  void retry() {
    profile = null;
    initialized = initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialized = initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (profile == null || profile is BackendError) {
              return RetryButton(
                onPressed: retry,
                error: profile,
                text: '프로필을 가져오지 못했습니다.',
              );
            }

            final data = profile as ProfileData;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 42, 26, 14),
                  child: Row(
                    children: [
                      ProfilePicture(
                        image: data.picture,
                        size: 110,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.nickname,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(data.email,
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit_outlined, size: 22),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        CardItem(
                            title: '남은 렌즈 30개',
                            icon: const Icon(
                              Icons.camera,
                              size: 32,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 22,
                            ),
                            onTap: () {}),
                        const SizedBox(height: 12),
                        CardItem(
                            title: '알림 설정',
                            icon: const Icon(
                              Icons.notifications_sharp,
                              size: 32,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 22,
                            ),
                            onTap: () {}),
                        const SizedBox(height: 12),
                        CardItem(
                            title: '개인정보 보호 설정',
                            icon: const Icon(
                              Icons.verified_user_rounded,
                              size: 36,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 22,
                            ),
                            onTap: () {}),
                        const SizedBox(height: 12),
                        CardItem(
                            title: '주문 내역',
                            icon: const Icon(
                              Icons.shopping_bag_rounded,
                              size: 36,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 22,
                            ),
                            onTap: () {}),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => showMessageDialog(context,
                                title: '로그아웃',
                                message: '정말로 로그아웃하고 로그인 페이지로 돌아가시겠어요?',
                                buttons: [
                                  MessageDialogButtion.closeButton(title: '취소'),
                                  MessageDialogButtion.closeButton(
                                      title: '확인',
                                      isDestructive: true,
                                      onTap: (_) => Auth.instance.logout().then(
                                          (_) => Navigator.pushReplacementNamed(
                                              context, '/'))),
                                ],
                                textAlign: TextAlign.center),
                            child: const Text(
                              '로그아웃',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  color: Color(0xFF7E7E7E)),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
