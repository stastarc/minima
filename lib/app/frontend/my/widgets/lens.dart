import 'package:flutter/material.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/models/lens/credit.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:minima/shared/widgets/future_wait.dart';
import 'package:minima/shared/widgets/rounded_card.dart';
import 'package:toast/toast.dart';
import 'package:tuple/tuple.dart';

class LensSheet extends StatefulWidget {
  final void Function(AnalysisCreditData) onUpdate;

  const LensSheet({
    super.key,
    required this.onUpdate,
  });

  @override
  State createState() => _LensSheetState();
}

class _LensSheetState extends State<LensSheet> {
  void onTab(Tuple3<int, int, int> item) {
    if (item.item3 != 0) {
      Toast.show(
        '현재 이 기능을 사용할 수 없습니다.',
      );
      return;
    }

    showMessageDialog(context,
        title: '렌즈 충전',
        message: '현재 렌즈 서비스는 베타버전으로 무료로 이용할 수 있어요.',
        textAlign: TextAlign.center,
        buttons: [
          MessageDialogButton.closeButton(
              title: '계속',
              onTap: (_) => futureWaitDialog<AnalysisCreditData>(context,
                  title: '렌즈 충전',
                  message: '렌즈를 충전하고 있어요.',
                  future: (() async {
                    return (await Lens.instance
                        .payCredit(item.item1 + item.item2))!;
                  })(),
                  onDone: (c) {
                    Toast.show('렌즈가 충전되었어요. 총 ${c.credit}개',
                        duration: Toast.lengthLong);
                    widget.onUpdate(c);
                  },
                  onError: (e) => Toast.show('렌즈가 충전되지 못했어요.\n$e',
                      duration: Toast.lengthLong)))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Column(
      children: [
        const Text('렌즈 충전',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        for (var item in const <Tuple3<int, int, int>>[
          Tuple3(2, 0, 0),
          Tuple3(10, 0, 1000),
          Tuple3(50, 5, 5000),
          Tuple3(100, 20, 10000)
        ]) ...[
          Opacity(
            opacity: item.item3 == 0 ? 1 : .35,
            child: GestureDetector(
                onTap: () => onTab(item),
                child: RCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.camera,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                            children: [
                              const TextSpan(text: '렌즈 '),
                              TextSpan(
                                  text: '${item.item1}개',
                                  style: const TextStyle(
                                      color: Color(0xFF13C750))),
                              if (item.item2 > 0)
                                TextSpan(
                                    text: ' + ${item.item2}개',
                                    style: const TextStyle(
                                        color: Color(0xFF13C750),
                                        fontSize: 12.5)),
                            ],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      const Spacer(),
                      Text(
                        item.item3 == 0
                            ? '광고 보기'
                            : '${currencyFormat(item.item3)}원',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 10),
        ],
        RichText(
          text: const TextSpan(
              children: [
                TextSpan(text: '구매를 진행하면 당사의 '),
                TextSpan(
                    text: '유료이용약관', style: TextStyle(color: Color(0xFF13C750))),
                TextSpan(text: '에 동의하는 것으로 간주합니다.\n청구 관련 문의는 '),
                TextSpan(
                    text: 'Giigke Payments 고객센터',
                    style: TextStyle(color: Color(0xFF13C750))),
                TextSpan(text: '로 접수해주시기 바랍니다.'),
              ],
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                  color: Colors.black45)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
