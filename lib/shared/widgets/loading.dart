import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color color;

  const Loading(
      {super.key,
      this.size = 50,
      this.color = const Color.fromARGB(255, 192, 195, 210)});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            LoadingAnimationWidget.staggeredDotsWave(color: color, size: size));
  }
}
