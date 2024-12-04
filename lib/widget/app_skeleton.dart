import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSkeleton extends StatelessWidget {
  final EdgeInsets? padding, margin;
  final double? height, width;
  final Widget? child;
  final BorderRadius? borderRadius;

  const AppSkeleton({
    super.key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF3F414E).withOpacity(0.2),
      highlightColor: Colors.grey,
      period: const Duration(milliseconds: 2000), // Kecepatan animasi
      child: child != null
          ? child!
          : Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(5),
                color: const Color(0xFF3F414E).withOpacity(0.2),
              ),
              height: height,
              padding: padding,
              margin: margin,
              width: width,
            ),
    );
  }
}
