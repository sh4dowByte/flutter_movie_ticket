import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/data/models/movie_detail.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_detail_provider.dart';
import 'package:flutter_movie_booking_app/widget/app_circle_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/pallete.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage(this.movieId, {super.key});
  final int movieId;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailProvider.notifier).fetchMovieDetails(widget.movieId);
    });

    // Tambahkan listener untuk mendeteksi perubahan posisi scroll
    _scrollController.addListener(() {
      showReadme = _scrollController.position.pixels < 280;

      setState(() {});
    });
  }

  bool showReadme = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // Fungsi untuk scroll ke bawah
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Posisi akhir
      duration: const Duration(milliseconds: 600), // Durasi animasi
      curve: Curves.easeInOut, // Jenis kurva animasi
    );
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
              expandedHeight: 500.0,
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
                    Row(
                      children: [
                        AppCircleButton(
                            onTap: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                        const SizedBox(width: 15),
                        AnimatedOpacity(
                          opacity: innnerBoxIsScrolled ? 1.0 : 0.0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            child: const Text(
                              'Arsenal vs Aston Villa prediction',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppCircleButton(
                      isTransparent: true,
                      icon: SvgPicture.asset(
                        'assets/icon/share.svg',
                        fit: BoxFit.fitHeight,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFFFFFFFF), BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: movieState.when(
                    data: (value) => CachedNetworkImage(
                      imageUrl: value.backdropUrlOriginal,
                      fit: BoxFit.cover,
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
                      loading: () =>
                          const Center(child: CircularProgressIndicator())),
                );
              },
            ),
            AnimatedOpacity(
              opacity: showReadme ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () {
                  _scrollToBottom();
                },
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          end: Alignment.topCenter, // Awal gradien
                          begin: Alignment.bottomCenter, // Akhir gradien

                          colors: [
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(0.6),
                            Colors.transparent, // Warna akhir
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 40),
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              colors: Pallete.gradientColor, // Warna gradien
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Read More'),
                              Icon(Icons.keyboard_arrow_down_rounded)
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  final MovieDetail movie;

  const MovieDetailContent({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie.title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 10),
          Text('Release Date: ${movie.releaseDate}'),
          const SizedBox(height: 10),
          Text(movie.overview),
        ],
      ),
    );
  }
}
