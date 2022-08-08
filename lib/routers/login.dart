import 'package:flutter/material.dart';
import 'package:minima/app/backend/auth/auth.dart';
import 'package:minima/shared/pllogo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  void onSuccess() {
    // 응 빠꾸야~
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 150, 35, 80),
          child: Column(
            children: [
              const PLLogo(size: 91),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('로그인',
                    style: TextStyle(
                        fontFamily: 'ibm',
                        fontSize: 36,
                        fontWeight: FontWeight.w800)),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('나만의 식물 전문가,\n플랜트 렌즈',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.3,
                          color: Color(0x993C3C3C),
                          fontFamily: 'display',
                          fontSize: 18))),
              Expanded(
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                    SocialButton(
                      type: SocialType.google,
                      onSuccess: onSuccess,
                      child: SvgPicture.asset(
                        'assets/images/icons/social/google.svg',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    SocialButton(
                      color: const Color(0xFFFEE500),
                      type: SocialType.kakao,
                      onSuccess: onSuccess,
                      child: SvgPicture.asset(
                        'assets/images/icons/social/kakao.svg',
                        width: 37,
                        height: 33,
                      ),
                    ),
                    SocialButton(
                      color: const Color(0xFF000000),
                      type: SocialType.apple,
                      onSuccess: onSuccess,
                      child: SvgPicture.asset(
                        'assets/images/icons/social/apple.svg',
                        width: 27,
                        height: 32,
                      ),
                    ),
                  ]))),
            ],
          ),
        )),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      this.child,
      this.color = Colors.white,
      required this.type,
      required this.onSuccess});

  final Widget? child;
  final Color color;
  final SocialType type;
  final Function onSuccess;

  Future<void> onPressed() async {
    Toast.show('로그인중입니다...', duration: Toast.lengthLong, gravity: Toast.bottom);
    switch (await Auth.instance.socialLogin(type)) {
      case SocialLoginStatus.success:
        onSuccess();
        break;
      case SocialLoginStatus.cancelled:
        Toast.show('로그인을 취소했어요.',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        break;
      case SocialLoginStatus.backendError:
        Toast.show('로그인 중 서버 오류가 발생했어요.',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        break;
      case SocialLoginStatus.socialError:
        Toast.show('로그인 중 오류가 발생했어요.',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 70,
      height: 70,
      onPressed: onPressed,
      color: color,
      padding: const EdgeInsets.all(16),
      shape: const CircleBorder(),
      child: child,
    );
  }
}
