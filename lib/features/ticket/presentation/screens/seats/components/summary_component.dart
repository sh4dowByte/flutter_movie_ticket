import 'package:flutter/material.dart';

class SummaryComponent extends StatelessWidget {
  const SummaryComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 24),
          summaryInfo(context, label: 'Date', info: 'Friday, 23th june 2024'),
          summaryInfo(context, label: 'Seats Selected', info: 'G9, G10'),
          summaryInfo(context, label: 'Location', info: 'Miami, Aventura 24'),
        ],
      ),
    );
  }

  Container summaryInfo(BuildContext context,
      {label = 'Date', info = 'Friday, 23th june 2024'}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            info,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
