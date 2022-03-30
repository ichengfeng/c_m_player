import 'package:c_m_player/pages/home/view/home_drawer.dart';
import 'package:c_m_player/pages/home/view/home_bottombar.dart';
import 'package:c_m_player/pages/home/view/home_content.dart';
import 'package:c_m_player/pages/home/view/home_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: HomeDrawer(),
      appBar: HomeNavBar(),
      body: HomeContent(),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
