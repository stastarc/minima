import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/frontend/market/topbar.dart';
import 'package:minima/app/frontend/market/pages/feed.dart';
import 'package:minima/shared/pllogo.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  double opacity = 0;

  Future<void> animate() async {
    while (mounted) {
      if (mounted) {
        setState(() {
          opacity = opacity == .1 ? .3 : .1;
        });
      }
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  }

  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  Widget build(BuildContext context) {
    return
        //
        //false
        kDebugMode
            ? ListView(
                scrollDirection: Axis.vertical,
                children: const [
                  MarketTopBar(),
                  FeedPage(),
                ],
              )
            : Stack(
                children: [
                  Positioned.fill(
                      child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(seconds: 2),
                          child: Image.asset('assets/images/dummy/market.jpg',
                              fit: BoxFit.cover))),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            PLLogo(size: 56),
                            SizedBox(width: 8),
                            Text('MARKET',
                                style: TextStyle(
                                    color: Color(0xFF4CC760),
                                    fontFamily: 'ibm',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('마켓을 준비하고있어요.',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 18)),
                        const SizedBox(height: 8),
                        const Text(
                            '전문 마켓에서 인테리어 식물을 구매해보세요.\n또한 내 식물을 등록하고, 다른 사람들의 식물을 구매할 수 있어요.',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14)),
                      ]),
                    ),
                  )
                ],
              );
  }
}
