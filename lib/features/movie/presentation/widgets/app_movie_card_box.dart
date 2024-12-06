import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/core/routes.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/movie.dart';
import 'package:flutter_movie_booking_app/widget/app_skeleton.dart';

class AppMovieCoverBox extends StatelessWidget {
  const AppMovieCoverBox({
    super.key,
    required this.item,
    required this.margin,
    this.replaceRoute = false,
  });

  final Movie item;
  final EdgeInsets margin;
  final bool replaceRoute;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        if (replaceRoute) {
          Navigator.pushReplacementNamed(context, Routes.movieDetail,
              arguments: item.id);
        } else {
          Navigator.pushNamed(context, Routes.movieDetail, arguments: item.id);
        }
      },
      child: Container(
        margin: margin,
        width: 162,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: CachedNetworkImage(
            imageUrl: item.imageUrlOriginal,
            placeholder: (context, url) => CachedNetworkImage(
              imageUrl: item.imageUrlW300, // Gambar thumbnail (ukuran kecil)
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  static Widget loading() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Jumlah skeleton placeholder
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: AppSkeleton(
              width: 162,
            ),
          );
        },
      ),
    );
  }
}
