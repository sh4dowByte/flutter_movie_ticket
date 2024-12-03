import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const AppButton({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF0B51B9),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
