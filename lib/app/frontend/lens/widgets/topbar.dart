import 'package:flutter/material.dart';

class TopBarView extends StatefulWidget {
  const TopBarView({super.key});
  @override
  State createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(children: const [
        SizedBox(width: 20),
        Icon(Icons.camera_sharp),
        SizedBox(width: 5),
        Text('8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Spacer(),
        Icon(Icons.flashlight_on_outlined),
        SizedBox(width: 20),
        Icon(Icons.help_outline),
        SizedBox(width: 20),
      ]),
    );
  }
}
