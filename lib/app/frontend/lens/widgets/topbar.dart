import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/lens/lens.dart';
import 'package:minima/app/frontend/lens/widgets/solution.dart';
import 'package:minima/app/models/lens/credit.dart';
import 'package:minima/shared/widgets/future_builder_widget.dart';

class TopBarView extends StatefulWidget {
  final void Function(FlashMode flush) onFlush;
  final void Function(VoidCallback onRefresh) onBuilder;

  const TopBarView({super.key, required this.onFlush, required this.onBuilder});
  @override
  State createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> {
  FlashMode flash = FlashMode.off;

  void onFlush() {
    switch (flash) {
      case FlashMode.torch:
        flash = FlashMode.off;
        break;
      case FlashMode.off:
      default:
        flash = FlashMode.torch;
        break;
    }
    widget.onFlush(flash);
    setState(() {});
  }

  void onHelp() {
    showSolutionDialog(context);
  }

  @override
  void initState() {
    super.initState();
    widget.onBuilder(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(children: [
        const SizedBox(width: 16),
        FutureBuilderWidget<AnalysisCreditData?>(
          future: Lens.instance.getCredit(),
          defaultBuilder: (credit) => Text('촬영 가능 횟수: ${credit?.credit ?? "·"}',
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onFlush,
          child: Icon(
              flash == FlashMode.off
                  ? BootstrapIcons.lightning_charge
                  : BootstrapIcons.lightning_charge_fill,
              size: 24),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onHelp,
          child: const Icon(CupertinoIcons.question_circle, size: 25),
        ),
        const SizedBox(width: 20),
      ]),
    );
  }
}
