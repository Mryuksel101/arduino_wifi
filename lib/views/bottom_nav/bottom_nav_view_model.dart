import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  int currentIndex = 0;

  late PageController _pageController;
  PageController get pageController => _pageController;

  void updateCurrentIndex(int index) {
    currentIndex = index;
  }

  void changeCurrentTab(int index) {
    currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  void _initPageController() {
    _pageController = PageController();
  }

  void init() {
    _initPageController();
  }
}
