import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/frontend/lens/pages/analysis.dart';
import 'package:minima/app/frontend/lens/widgets/bottombar.dart';
import 'package:minima/app/frontend/lens/widgets/camera.dart';
import 'package:minima/app/frontend/lens/widgets/topbar.dart';
import 'package:minima/routers/_route.dart';
import 'package:minima/routers/main.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:toast/toast.dart';

import 'widgets/grid.dart';

class LensPage extends StatefulWidget {
  const LensPage({super.key});

  @override
  State createState() => _LensPageState();
}

class _LensPageState extends State<LensPage> {
  Future<File?> Function()? _onCamera;
  VoidCallback? _onChange, _onTopBarRefresh;
  void Function(FlashMode flush)? _flush;
  bool _isPaused = false, _isCaptured = false;

  @override
  void initState() {
    super.initState();
  }

  void pause() {
    setState(() {
      _isPaused = true;
    });
  }

  void resume() {
    setState(() {
      _isPaused = false;
    });
  }

  void onGallery() async {
    try {
      pause();
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      if (mounted) {
        await Navigator.push(
            context,
            slideRTL(AnalysisPage(
              image: await image.readAsBytes(),
            )));
      }
    } catch (e) {
      Toast.show('사진을 읽을 수 없어요.\n$e', duration: Toast.lengthLong);
    } finally {
      resume();
    }
  }

  void onCamera() async {
    if (_onCamera == null || _isCaptured) return;
    _isCaptured = true;
    try {
      final data = (await _onCamera!())?.readAsBytesSync() ??
          (kDebugMode
              ? (await rootBundle.load('assets/images/dummy/질병.jpg'))
                  .buffer
                  .asUint8List()
              : null);
      // final data = (kDebugMode
      //     ? (await rootBundle.load('assets/images/dummy/질병.jpg'))
      //         .buffer
      //         .asUint8List()
      //     : null);

      if (data == null) {
        return;
      }

      final credit = await Lens.instance.getCredit();

      if (credit.credit < 1) {
        if (mounted) {
          showMessageDialog(context,
              title: '크레딧 부족',
              message: '분석에 필요한 크레딧이 부족해요.\n크레딧 충전 페이지로 이동할까요?',
              buttons: [
                MessageDialogButton.closeButton(title: '취소'),
                MessageDialogButton.closeButton(
                    onTap: (_) => MainPage.tabMoveTo(MainPage.MyPage))
              ]);
        }
        return;
      }

      if (mounted) {
        pause();
        await Navigator.push(
            context,
            slideRTL(AnalysisPage(
              image: data,
            )));
        if (_onTopBarRefresh != null) _onTopBarRefresh!();
      }
    } catch (e) {
      Toast.show('카메라를 사용할 수 없어요.\n$e', duration: Toast.lengthLong);
    } finally {
      _isCaptured = false;
      resume();
    }
  }

  void onChange() {
    if (_onChange != null) {
      _onChange!();
    }
  }

  void onFlush(FlashMode flush) {
    if (_flush != null) {
      _flush!(flush);
    }
  }

  void onBuilder(VoidCallback change, void Function(FlashMode flush) flush,
      Future<File?> Function() capture) {
    _onCamera = capture;
    _onChange = change;
    _flush = flush;
  }

  void onTopBarBuilder(VoidCallback onTopBarRefresh) {
    _onTopBarRefresh = onTopBarRefresh;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 52,
            bottom: 130 - 16,
            left: 0,
            right: 0,
            child: _isPaused
                ? Ink(
                    color: Colors.black,
                  )
                : CameraView(
                    onBuilder: onBuilder,
                  )),
        ...buildCameraGrid(context),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBarView(
              onFlush: onFlush,
              onBuilder: onTopBarBuilder,
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 130,
          child: BottomBarView(
            onGallery: onGallery,
            onCamera: onCamera,
            onChange: onChange,
          ),
        )
      ],
    );
  }
}
