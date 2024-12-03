import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppImageSlider extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const AppImageSlider({super.key, required this.data});

  @override
  State<AppImageSlider> createState() => _AppImageSliderState();
}

class _AppImageSliderState extends State<AppImageSlider>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 3), // Set the duration for the progress animation
    );

    // Timer untuk mengubah halaman otomatis setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer ketika widget di-destroy
    _animationController.dispose(); // Hapus controller animasi
    super.dispose();
  }

  void _onTimerTick(Timer timer) {
    setState(() {
      if (_animationController.isCompleted) {
        // Pindah ke halaman berikutnya ketika progress selesai
        if (_currentIndex < widget.data.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _animationController.reset();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.data.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              _animationController
                  .reset(); // Reset animasi saat halaman diganti
            });
          },
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.data[index]['image'],
                    fit: BoxFit
                        .cover, // Gambar akan memenuhi area tanpa mengubah proporsi
                  ),
                ),

                // Image
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex--;

                          if (_currentIndex < 0) {
                            _currentIndex = widget.data.length - 1;
                          }

                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                          _animationController
                              .reset(); // Reset animasi saat halaman diganti
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_currentIndex < widget.data.length - 1) {
                            _currentIndex++;
                          } else {
                            _currentIndex = 0;
                          }

                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          _animationController
                              .reset(); // Reset animasi saat halaman diganti
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ],
                ),

                // Backdroop
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.topCenter, // Awal gradien
                        begin: Alignment.bottomCenter, // Akhir gradien
                        colors: [
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(1),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(1),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.7),
                          Colors.transparent, // Warna akhir
                        ],
                      ),
                    ),

                    // Title
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20)
                          .copyWith(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data[_currentIndex]['title'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                end: Alignment.topCenter, // Awal gradien
                                begin: Alignment.bottomCenter, // Akhir gradien
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.1), // Warna akhir
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
                  ),
                ),

                // Backdrop top
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.bottomCenter, // Awal gradien
                        begin: Alignment.topCenter, // Akhir gradien
                        colors: [
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),

                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.5),
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.2),
                          Colors.transparent, // Warna akhir
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Indicator
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                widget.data.length,
                (index) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final maxWidth =
                      screenWidth / widget.data.length - 10; // Proporsional
                  const double activeWidth = 41; // Batas panjang aktif
                  final double inactiveWidth =
                      maxWidth > 16 ? 16 : maxWidth / 2; // Panjang nonaktif

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: _currentIndex == index ? activeWidth : inactiveWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Visibility(
                      visible: _currentIndex == index,
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Container(
                                height: 8,
                                width: _animationController.value *
                                    activeWidth, // Progress width dinamis
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B51B9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
