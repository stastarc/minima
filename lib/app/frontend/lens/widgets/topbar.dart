import 'package:camera/camera.dart';
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
      case FlashMode.off:
        flash = FlashMode.auto;
        break;
      case FlashMode.auto:
        flash = FlashMode.always;
        break;
      case FlashMode.always:
      default:
        flash = FlashMode.off;
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
                  ? Icons.flash_off_rounded
                  : flash == FlashMode.auto
                      ? Icons.flash_auto_rounded
                      : Icons.flash_on_rounded,
              size: 28),
        ),
        const SizedBox(width: 20),
        const Icon(Icons.help_outline),
        const SizedBox(width: 20),
      ]),
    );
  }
}
