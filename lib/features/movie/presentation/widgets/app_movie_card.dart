import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/core/routes.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/movie.dart';
import 'package:flutter_movie_booking_app/features/movie/presentation/widgets/star_rating.dart';
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
              imageUrl: item.imageUrlW200, // Gambar thumbnail (ukuran kecil)
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

class AppMovieCoverTile extends StatelessWidget {
  const AppMovieCoverTile({
    super.key,
    required this.item,
    this.replaceRoute = false,
  });

  final Movie item;
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
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Stack(
          children: [
            // Content
            Positioned(
                left: 120,
                top: 10,
                right: 0,
                child: Text(
                  item.title,
                  overflow: TextOverflow.ellipsis,
                )),
            Positioned(
              bottom: 20,
              left: 100,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StarRating(
                          rating: item.voteAverage,
                          starSize: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${item.releaseDate.isNotEmpty ? DateTime.parse(item.releaseDate).year : 'Unknown'})',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.overview,
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Image
            SizedBox(
              height: 162,
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrlOriginal,
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl:
                        item.imageUrlW200, // Gambar thumbnail (ukuran kecil)
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget loading() {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10, // Jumlah skeleton placeholder
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AppSkeleton(
                    height: 162,
                    width: 110,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        AppSkeleton(
                          height: 30,
                        ),
                        SizedBox(height: 10),
                        AppSkeleton(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
