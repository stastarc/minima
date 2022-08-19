import 'package:flutter/material.dart';
import 'package:minima/app/frontend/market/topbar.dart';
import 'package:minima/app/frontend/market/pages/feed.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          MarketTopBar(),
          FeedPage(),
        ],
      ),
    );
  }
}
