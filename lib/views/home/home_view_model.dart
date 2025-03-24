import 'dart:async';

import 'package:arduino_wifi/views/add_arrow_record/view/add_arrow_record_view.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  BuildContext context;
  HomeViewModel(this.context);

  void openAddArrowRecordView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddArrowRecordView(),
      ),
    );
  }

  Future<void> init() async {}
}
