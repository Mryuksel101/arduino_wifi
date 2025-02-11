import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:arduino_wifi/about/about_view.dart';
import 'package:arduino_wifi/bottom_nav/bottom_nav_view_model.dart';
import 'package:arduino_wifi/home/home_view.dart';
import 'package:flutter/material.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late final BottomNavViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = BottomNavViewModel();
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          viewModel.changeCurrentTab(4);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ListenableBuilder(
          listenable: viewModel,
          builder: (context, widget) {
            return AnimatedBottomNavigationBar(
              backgroundColor: Colors.white,
              activeColor: const Color(0xff0079FF),
              onTap: (value) {
                viewModel.changeCurrentTab(value);
              },
              iconSize: 26,
              icons: const [
                Icons.window_rounded,
                Icons.info,
              ],
              activeIndex: viewModel.currentIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
            );
          }),
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: viewModel.pageController,
          children: [
            const HomeView(),
            const AboutView(),
          ]),
    );
  }
}
