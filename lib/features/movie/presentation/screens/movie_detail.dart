import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/movie_detail.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_caster.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_detail_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_recomended_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../widget/app_skeleton.dart';
import '../widgets/app_cast_image.dart';
import '../widgets/app_movie_card.dart';
import '../widgets/star_rating.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage(this.movieId, {super.key});
  final int movieId;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  // late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailProvider.notifier).fetchMovieDetails(widget.movieId);
      ref
          .read(recomendedMoviesProvider.notifier)
          .fetchRecommendedMovies(widget.movieId, isInit: true);
    });

    // _controller = YoutubePlayerController(
    //   initialVideoId:
    //       'tzQsSmDc8gw', // Ganti dengan ID video YouTube yang ingin Anda tampilkan
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //   ),
    // );
  }

  bool showReadme = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    // _controller.dispose();
    super.dispose();
  }

  String formatRuntime(int runtime) {
    final hours = runtime ~/ 60; // Hitung jam
    final minutes = runtime % 60; // Sisa menit
    return '$hours h $minutes min';
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieDetailProvider);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innnerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0.0,
              centerTitle: false,
              elevation: 0.0,
              leadingWidth: 0.0,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                        )),
                    // const SizedBox(width: 15),
                    // InkWell(
                    //     onTap: () => Navigator.popUntil(
                    //           context,
                    //           (route) => route
                    //               .isFirst, // Kembali hingga halaman pertama
                    //         ),
                    //     child: const Icon(
                    //       Icons.close,
                    //     )),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: movieState.when(
                    data: (value) => Stack(
                      children: [
                        CachedNetworkImage(
                          height: double.infinity,
                          imageUrl: value.backdropUrlOriginal,
                          placeholder: (context, string) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: value.backdropUrlW300,
                                  fit: BoxFit.cover,
                                ),
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                        // Backdrop top
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter, // Awal gradien
                                end: Alignment.topCenter, // Akhir gradien
                                colors: [
                                  Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(1),
                                  Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.9),

                                  Colors.transparent, // Warna akhir
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                child: CachedNetworkImage(
                                  height: 150,
                                  width: 100,
                                  imageUrl: value.imageUrlW300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            value.genres
                                                .map((e) => e.name.toString())
                                                .join(', '),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        if (value.adult) ...[
                                          CachedNetworkImage(
                                              width: 28,
                                              height: 28,
                                              imageUrl:
                                                  'https://img.icons8.com/?size=480&id=o3iN2IEeyqAq&format=png'),
                                        ],
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${DateTime.parse(value.releaseDate).year} ⦿ ${formatRuntime(value.runtime)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 9),
                                    StarRating(rating: value.voteAverage),
                                    const SizedBox(height: 9),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          end: Alignment
                                              .topCenter, // Awal gradien
                                          begin: Alignment
                                              .bottomCenter, // Akhir gradien
                                          colors: [
                                            Colors.white.withOpacity(0.1),
                                            Colors.white.withOpacity(
                                                0.1), // Warna akhir
                                          ],
                                        ),
                                      ),
                                      width: 130,
                                      height: 34,
                                      child: const Row(
                                        children: [
                                          Icon(Icons.play_arrow_rounded),
                                          SizedBox(width: 10),
                                          Text(
                                            'Play Trailer',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Center(
                        //   child: YoutubePlayer(
                        //     controller: _controller,
                        //     showVideoProgressIndicator:
                        //         true, // Menampilkan progress bar video
                        //   ),
                        // ),
                      ],
                    ), // Data berhasil dimuat
                    loading: () => const Text(''),
                    error: (error, stackTrace) =>
                        Center(child: Text('Error: $error')),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            Builder(
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: movieState.when(
                      data: (data) => MovieDetailContent(movie: data),
                      error: (error, stackTrace) =>
                          Center(child: Text('Error: $error')),
                      loading: () => MovieDetailContent.loading()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailContent extends ConsumerStatefulWidget {
  final MovieDetail movie;
  const MovieDetailContent({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailContent> createState() => _MovieDetailContentState();

  static Widget loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSkeleton(height: 40),
          const SizedBox(height: 10),
          const AppSkeleton(height: 40),
          const SizedBox(height: 10),
          const AppSkeleton(
            height: 30,
            width: 200,
          ),
          const SizedBox(height: 20),
          ...List.generate(6, (index) => index + 1).map((item) {
            return const Column(
              children: [
                AppSkeleton(height: 15),
                SizedBox(height: 5),
              ],
            );
          }),
          const SizedBox(height: 20),
          AppCastImage.loading(),
          const SizedBox(height: 20),
          AppMovieCoverBox.loading()
        ],
      ),
    );
  }
}

class _MovieDetailContentState extends ConsumerState<MovieDetailContent> {
  final ScrollController _scrollControllerRecomended = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieCasterProvider.notifier).fetchMovieCaster(widget.movie.id);
    });

    _scrollControllerRecomended.addListener(() {
      if (_scrollControllerRecomended.position.pixels >=
          _scrollControllerRecomended.position.maxScrollExtent) {
        ref
            .read(recomendedMoviesProvider.notifier)
            .fetchRecommendedMovies(widget.movie.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recomendedState = ref.watch(recomendedMoviesProvider);
    final casterState = ref.watch(movieCasterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.movie.title,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 10),
              Text(
                'Release Date: ${widget.movie.releaseDate}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Text(widget.movie.overview),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Caster
        Offstage(
          offstage:
              !(casterState.value != null && casterState.value!.isNotEmpty),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            child: const Text('Cast'),
          ),
        ),

        casterState.when(
          data: (data) => data.isNotEmpty
              ? SizedBox(
                  height: 130,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        EdgeInsets margin = EdgeInsets.only(
                          left: index == 0 ? 11 : 4,
                          right: index == data.length - 1 ? 11 : 4,
                        );

                        return AppCastImage(item: item, margin: margin);
                      }),
                )
              : Container(),
          loading: () => AppMovieCoverBox.loading(),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),

        const SizedBox(height: 20),

        // Recomended
        Offstage(
          offstage: !(recomendedState.value != null &&
              recomendedState.value!.isNotEmpty),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            child: const Text('Recomended'),
          ),
        ),
        recomendedState.when(
          data: (data) => data.isNotEmpty
              ? SizedBox(
                  height: 220,
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollControllerRecomended,
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        EdgeInsets margin = EdgeInsets.only(
                          left: index == 0 ? 20 : 4,
                          right: index == data.length - 1 ? 20 : 4,
                        );

                        return AppMovieCoverBox(
                          item: item,
                          margin: margin,
                          replaceRoute: true,
                        );
                      }),
                )
              : Container(),
          loading: () => AppMovieCoverBox.loading(),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
