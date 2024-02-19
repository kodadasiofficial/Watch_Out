import 'package:flutter/material.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/ui/pages/main_pages/nearest_latest.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _tabBar = TabBar(
    dividerHeight: 0,
    indicatorColor: Palette.darkGreen,
    labelColor: Palette.darkGreen,
    tabs: const [
      Tab(
        text: "Nearest",
      ),
      Tab(
        text: "Latest",
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Palette.mainPage,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              color: Palette.mainPage,
              child: _tabBar,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            NearestLatestPage(
              latest: false,
            ),
            NearestLatestPage(
              latest: true,
            ),
          ],
        ),
      ),
    );
  }
}
