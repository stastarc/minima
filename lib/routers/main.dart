import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/frontend/lens/main.dart';
import 'package:minima/app/frontend/my/main.dart';
import 'package:minima/app/frontend/myplant/main.dart';
import 'package:minima/app/frontend/market/main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Color getTabColor(int index) {
    return tabController.index == index
        ? const Color(0xFF54CF8B)
        : const Color(0xFF3D3D3D);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              MyPlantPage(),
              LensPage(),
              MarketPage(),
              MyPage(),
            ]),
        bottomNavigationBar: TabBar(
          controller: tabController,
          labelColor: const Color(0xFF3D3D3D),
          indicatorColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          tabs: [
            Tab(icon: Icon(FluentIcons.book_24_filled, color: getTabColor(0))),
            Tab(icon: Icon(Icons.camera_sharp, color: getTabColor(1))),
            Tab(icon: Icon(Icons.shopping_bag, color: getTabColor(2))),
            Tab(icon: Icon(Icons.person, color: getTabColor(3))),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
