import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Offset? _tapPosition;

  void _updateTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: _updateTapPosition,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              Center(
                child: Text("Settings View"),
              ),
              if (_tapPosition != null)
                Positioned(
                  left: _tapPosition!.dx,
                  top: _tapPosition!.dy,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _tapPosition == null
                          ? "Ekrana dokunun"
                          : "X: ${_tapPosition!.dx.toStringAsFixed(2)}, Y: ${_tapPosition!.dy.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
