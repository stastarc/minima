import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:minima/app/frontend/my/widgets/card_item.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/rounded_card.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});
  @override
  State createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
        title: '개인정보 보호',
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RCard(
              child: Column(children: [
                const Text('개인정보 보호 정책',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<String>(
                      future: rootBundle.loadString('assets/html/privacy.md'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return MarkdownBody(data: snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
              ]),
            )
          ],
        ));
  }
}
