import 'package:flutter/material.dart';
import 'package:minima/app/frontend/myplant/main.dart';
import 'package:minima/routers/lens.dart';
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
    tabController = TabController(vsync: this, length: 5);
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
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Text('검색'),
              MyPlantPage(),
              LensPage(),
              MarketPage(),
              Text('마이'),
            ]),
        bottomNavigationBar: TabBar(
          controller: tabController,
          labelColor: const Color(0xFF3D3D3D),
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(icon: Icon(Icons.search, color: getTabColor(0))),
            Tab(icon: Icon(Icons.book, color: getTabColor(1))),
            Tab(icon: Icon(Icons.camera_sharp, color: getTabColor(2))),
            Tab(icon: Icon(Icons.shopping_bag, color: getTabColor(3))),
            Tab(icon: Icon(Icons.person, color: getTabColor(4))),
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
