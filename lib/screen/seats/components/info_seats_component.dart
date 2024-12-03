import 'package:flutter/material.dart';

class InfoSeatsComponent extends StatelessWidget {
  const InfoSeatsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        infoSeat(),
        infoSeat(text: 'Availabe', color: const Color(0xFF29A1FD)),
        infoSeat(text: 'Selected', color: const Color(0xFFB3FE4B)),
      ],
    );
  }

  Row infoSeat(
      {Color color = const Color(0xFF2F3436), String text = 'Not Availabe'}) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 6, left: 12),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
