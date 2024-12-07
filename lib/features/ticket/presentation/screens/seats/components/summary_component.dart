import 'package:flutter/material.dart';

class SummaryComponent extends StatelessWidget {
  final String date;
  final String seat;
  final String location;
  const SummaryComponent({
    super.key,
    required this.date,
    required this.seat,
    required this.location,
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
          summaryInfo(context, label: 'Date', info: date),
          summaryInfo(context, label: 'Seats Selected', info: seat),
          summaryInfo(context, label: 'Location', info: location),
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
          SizedBox(
            width: 200,
            child: Text(
              info,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
