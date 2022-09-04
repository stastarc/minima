import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/shared/widgets/dialog.dart';
import 'package:tuple/tuple.dart';

void showSolutionDialog(BuildContext context) {
  showMessageDialog(context,
      title: '촬영 방법',
      message: '',
      buttons: [MessageDialogButton.closeButton()],
      body: SolutionView(
          width: MediaQuery.of(context).size.width * .8, isDialog: true));
}

class SolutionView extends StatelessWidget {
  final double width;
  final bool isDialog;

  const SolutionView({super.key, required this.width, this.isDialog = false});

  @override
  Widget build(BuildContext context) {
    final scale = isDialog ? 0.8 : 1;
    var i = 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var solution in const [
          Tuple3('1. 하나의 식물만 촬영하세요.', 'LCEuKF4idgq31mtt5nkTVgzHXYky4z1n',
              'Ks4DybPyeSqg28KpBIAh86LWEnUYY66I'),
          Tuple3(
              '2. 식물의 부위 하나만 가운데에 위치시키세요.',
              'Zn0DUd2hfTgXNCf1cmhHGk3wd6bnuaqN',
              'vbNk7cXK89qGZkmfkApwtrxJtWoT3eSi')
        ]) ...[
          if (i++ > 0) const SizedBox(height: 12),
          Ink(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 8, horizontal: isDialog ? 0 : 32),
            child: Text(
              solution.item1,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: isDialog
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly,
            children: [
              for (var item in const [false, true])
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(children: [
                    CDN.image(
                        id: item ? solution.item3 : solution.item2,
                        width: width * 0.4,
                        height: isDialog ? 120 : 140,
                        fit: BoxFit.cover),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: 42.0 * scale,
                          height: 42.0 * scale,
                          child: Material(
                              color: (item ? Colors.green : Colors.red)
                                  .withOpacity(.8),
                              child: Center(
                                child: Icon(
                                    item ? Icons.check : Icons.close_rounded,
                                    size: 32.0 * scale,
                                    color: Colors.white),
                              )),
                        )),
                  ]),
                ),
            ],
          )
        ],
      ],
    );
  }
}
