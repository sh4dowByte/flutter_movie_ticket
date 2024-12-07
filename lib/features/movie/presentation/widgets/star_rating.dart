import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // Nilai rating (misalnya 7.5 dari 10)
  final int maxRange; // Total range nilai (default: 10)
  final int maxStars; // Jumlah maksimal bintang yang ditampilkan
  final Color starColor; // Warna bintang
  final double starSize; // Ukuran bintang

  const StarRating({
    super.key,
    required this.rating,
    this.maxRange = 10,
    this.maxStars = 5,
    this.starColor = Colors.amber,
    this.starSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    // Konversi rating dari range ke jumlah bintang
    final double starRating = (rating / maxRange) * maxStars;

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(
        rating.toString(),
        style: TextStyle(color: starColor, fontSize: starSize / (8 / 6)),
      ),
      const SizedBox(width: 10),
      ...List.generate(maxStars, (index) {
        if (index < starRating.floor()) {
          return Icon(
            Icons.star,
            color: starColor,
            size: starSize,
          );
        } else if (index < starRating) {
          return Icon(
            Icons.star_half,
            color: starColor,
            size: starSize,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: starColor,
            size: starSize,
          );
        }
      }),
    ]);
  }
}
