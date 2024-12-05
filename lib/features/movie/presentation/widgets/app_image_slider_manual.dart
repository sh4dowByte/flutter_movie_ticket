import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageSliderManual extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const AppImageSliderManual({super.key, required this.data});

  @override
  State<AppImageSliderManual> createState() => _AppImageSliderManualState();
}

class _AppImageSliderManualState extends State<AppImageSliderManual> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        if (widget.data.isNotEmpty) ...[
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.data[_currentPage.toInt()]['image']!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ],

        // Blur filter and gradient overlay
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(1), // Top darker
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.5), // Center lighter
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(1), // Bottom darker
                  ],
                ),
              ),
            ),
          ),
        ),

        // Image slider with titles and details
        PageView.builder(
          controller: _pageController,
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            // Calculate scaling effect for current page
            final scale = (_currentPage - index).abs() < 1
                ? 1 - (_currentPage - index).abs() * 0.2
                : 0.8;

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: scale, end: scale),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // Title
                    Text(
                      widget.data[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Additional details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.av_timer_rounded,
                          size: 16,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '1 HR 36 MIN | PG',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Image content
                    SizedBox(
                      width: double.infinity,
                      height: 391,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: widget.data[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
