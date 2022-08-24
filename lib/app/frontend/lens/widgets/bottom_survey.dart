import 'package:flutter/material.dart';

class BottomSurveryView extends StatelessWidget {
  const BottomSurveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      color: const Color(0xFFF9F9F9),
      child: Column(children: [
        const Text('위의 내용이 도움이 되셨나요?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 140,
              height: 42,
              child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('좋아요',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D3D3D)))),
            ),
            SizedBox(
              width: 140,
              height: 42,
              child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('별로에요',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D3D3D)))),
            )
          ],
        )
      ]),
    );
  }
}
