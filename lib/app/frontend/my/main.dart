import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/auth.dart';
import 'package:minima/app/backend/auth/user.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/frontend/my/pages/notify.dart';
import 'package:minima/app/frontend/my/pages/privacy.dart';
import 'package:minima/app/frontend/my/pages/profile_edit.dart';
import 'package:minima/app/frontend/my/widgets/card_item.dart';
import 'package:minima/app/frontend/my/widgets/feedback.dart';
import 'package:minima/app/frontend/my/widgets/lens.dart';
import 'package:minima/app/frontend/my/widgets/profile_picture.dart';
import 'package:minima/app/models/auth/profile.dart';
import 'package:minima/app/models/lens/credit.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/bottom_sheet.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:minima/shared/widgets/future_builder_widget.dart';
import 'package:minima/shared/widgets/retry.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<void> initialized;
  late Future<AnalysisCreditData?> _credit;
  dynamic profile;

  Future<void> initialize() async {
    try {
      profile = await User.instance.getMyCached();
    } catch (e) {
      profile = BackendError.fromException(e);
    }
  }

  void onProfileUpdate(ProfileData data) {
    setState(() {
      profile = data;
    });
  }

  void onCreditUpdate(AnalysisCreditData credit) {
    setState(() {
      _credit = Future.value(credit);
    });
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
    _credit = Lens.instance.getCredit();
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
                        size: 92,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.nickname,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(data.email,
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            slideRTL(ProfileEditPage(
                              profile: profile,
                              onUpdate: onProfileUpdate,
                            ))),
                        child: const Icon(Icons.edit_outlined, size: 22),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        FutureBuilderWidget<AnalysisCreditData?>(
                            future: _credit,
                            defaultBuilder: (credit) => CardItem(
                                title:
                                    '남은 렌즈 ${credit != null ? "${credit.credit}개" : ""}',
                                icon: const Icon(
                                  Icons.camera,
                                  size: 28,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                ),
                                onTap: () {
                                  showSheet(context,
                                      child: LensSheet(
                                        onUpdate: onCreditUpdate,
                                      ));
                                })),
                        const SizedBox(height: 12),
                        CardItem(
                          title: '알림 설정',
                          icon: const Icon(
                            Icons.notifications_sharp,
                            size: 28,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                          onTap: () =>
                              Navigator.push(context, slideRTL(NotifyPage())),
                        ),
                        const SizedBox(height: 12),
                        CardItem(
                          title: '개인정보 보호',
                          icon: const Icon(
                            Icons.verified_user_rounded,
                            size: 28,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                          onTap: () => Navigator.push(
                              context, slideRTL(const PrivacyPage())),
                        ),
                        const SizedBox(height: 12),
                        CardItem(
                            title: '피드백 보내기',
                            icon: const Icon(
                              Icons.chat,
                              size: 28,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                            ),
                            onTap: () => showSheet(context,
                                child: const FeedbackSheet())),
                        const SizedBox(height: 12),
                        // CardItem(
                        //     title: '주문 내역',
                        //     icon: const Icon(
                        //       Icons.shopping_bag_rounded,
                        //       size: 36,
                        //     ),
                        //     child: const Icon(
                        //       Icons.arrow_forward_ios_rounded,
                        //       size: 22,
                        //     ),
                        //     onTap: () {}),
                        // const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => showMessageDialog(context,
                                title: '로그아웃',
                                message: '정말로 로그아웃하고 로그인 페이지로 돌아가시겠어요?',
                                buttons: [
                                  MessageDialogButton.closeButton(title: '취소'),
                                  MessageDialogButton.closeButton(
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
                                  fontSize: 11,
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
