import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBarView extends StatefulWidget {
  final void Function(FlashMode flush) onFlush;

  const TopBarView({super.key, required this.onFlush});
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(children: [
        const SizedBox(width: 20),
        const Icon(Icons.camera_sharp),
        const SizedBox(width: 5),
        const Text('8',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
        const Icon(CupertinoIcons.question_circle, size: 25),
        const SizedBox(width: 20),
      ]),
    );
  }
}
