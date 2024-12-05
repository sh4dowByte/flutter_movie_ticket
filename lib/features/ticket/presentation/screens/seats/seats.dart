import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/ticket/presentation/screens/seats/components/seats_layout_component.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/info_seats_component.dart';
import 'components/summary_component.dart';

class SeatsPage extends ConsumerWidget {
  const SeatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: const [
              // Seats
              Center(
                child: SizedBox(
                  height: 500,
                  child: SeatLayoutComponent(),
                ),
              ),

              // Info seats
              InfoSeatsComponent(),
              SizedBox(height: 20),

              // Summary
              SummaryComponent(),
            ],
          ),
          // Bottom info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '\$ 23.00',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '2 seats',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  const Expanded(
                    child: AppButton(
                      text: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
