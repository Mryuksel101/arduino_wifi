import 'package:arduino_wifi/views/home/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = HomeViewModel(context);
    _vm.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: const Text('App Name'),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: FloatingActionButton.extended(
                  heroTag: "btn1",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  backgroundColor: Colors.blue,
                  onPressed: _vm.openAddArrowRecordView,
                  label: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add Arrow Record",
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 0.5),
                      )
                    ],
                  ),
                ),
              ),
              body: Center(
                child: Text("Home View",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              )),
        );
      },
    );
  }
}
