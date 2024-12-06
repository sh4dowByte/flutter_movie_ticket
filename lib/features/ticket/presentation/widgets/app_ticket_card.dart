import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../movie/data/models/movie.dart';

class AppTicketCard extends StatelessWidget {
  final Movie data;
  const AppTicketCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: CachedNetworkImage(
                imageUrl: data.imageUrlW500,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),

          // content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Scotiabank Theatre Ottawa',
                          style: TextStyle(fontSize: 12),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.local_parking_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.2,
                    color: Colors.white.withOpacity(0.3),
                  ),

                  // content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // title and image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                data.title,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: data.imageUrlW300,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // date
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tue, Jul 30'),
                            Text('07.00 PM'),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, size: 15),
                                SizedBox(width: 5),
                                Text('2h 24min'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // location
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'AUDITORIUM',
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 11),
                                    ),
                                    Text(
                                      '07',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ROW',
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 11),
                                    ),
                                    Text(
                                      'J',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SEAT',
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 11),
                                    ),
                                    Text(
                                      '15',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Share
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.save_alt, size: 18),
                                  SizedBox(width: 10),
                                  Text('Save to gallery')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Barcode
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CPX TUESDAY',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    generateBarcode('T7404646288750988'),
                    const Text('T7404646288750988',
                        style: TextStyle(color: Colors.black, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Function to generate barcode
  Widget generateBarcode(String data) {
    final Barcode barcode = Barcode
        .code128(); // You can change to other types like Barcode.qrCode()
    final svg = barcode.toSvg(data,
        width: 200, height: 60, drawText: false); // Generate barcode as SVG

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SvgPicture.string(
        svg,
        semanticsLabel: 'Generated Barcode',
      ),
    );
  }
}
