import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/widgets/analysis.dart';
import 'package:minima/shared/widgets/page.dart';

class AnalysisPage extends StatefulWidget {
  // final File image;
  final File? image;

  const AnalysisPage({super.key, required this.image});

  @override
  State createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  Widget buildBody() {
    return ListView(
      children: [
        const SizedBox(height: 250 - 12 - 2),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: const [
            SizedBox(height: 26),
            Text(
              'adsfgfhgrsfea',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'afsgdhfyrtgsead',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              const SizedBox(
                width: double.infinity,
                height: 250,
                child: AnalysisAnimationView(
                  width: double.infinity,
                  height: 250,
                ),
              ),
              Positioned(
                  top: 0, bottom: 0, left: 0, right: 0, child: buildBody())
            ])));
  }
}
