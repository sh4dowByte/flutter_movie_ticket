import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/widget/app_skeleton.dart';

import '../../data/models/cast.dart';

class AppCastImage extends StatelessWidget {
  const AppCastImage({
    super.key,
    required this.item,
    this.margin,
  });

  final Cast item;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: margin,
          height: 80, // Tinggi sama
          width: 80, // Lebar sama
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(40), // Setengah dari tinggi/lebar
            child: CachedNetworkImage(
              imageUrl: item.imageUrlW300,
              placeholder: (context, string) {
                return CachedNetworkImage(
                  imageUrl:
                      'https://img.icons8.com/?size=480&id=z-JBA_KtSkxG&format=png',
                  fit: BoxFit.cover,
                );
              },
              fit: BoxFit.cover, // Memastikan gambar memenuhi lingkaran
            ),
          ),
        ),
        Container(
          width: 110,
          margin: margin,
          child: Column(
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              Text(item.character,
                  style: const TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }

  static Widget loading() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Jumlah skeleton placeholder
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: const AppSkeleton(
                width: 80,
              ),
            ),
          );
        },
      ),
    );
  }
}
