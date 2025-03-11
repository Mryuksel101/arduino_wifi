import 'package:flutter/material.dart';

class SdButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback? onPressed;
  final bool isSubscribed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double? radius;
  final double? width;
  final double? height;
  const SdButton(
      {super.key,
      this.loading = false,
      required this.text,
      this.onPressed,
      this.isSubscribed = false,
      this.foregroundColor = Colors.white,
      this.backgroundColor = const Color(0xff0055ff),
      this.radius,
      this.textColor,
      this.width = 84,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.white,
          minimumSize: Size(width!, height!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 50), // rounded-full
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          foregroundColor: foregroundColor,
          backgroundColor: isSubscribed ? Colors.orange : backgroundColor),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ))
          : Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14, // text-sm
                fontWeight: FontWeight.bold, // font-bold
                letterSpacing: 0.015, // tracking-[0.015em]
                overflow: TextOverflow.ellipsis, // truncate
              ),
            ),
    );
  }
}
