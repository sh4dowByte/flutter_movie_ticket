import 'package:flutter/material.dart';

class AppSelectTime extends StatefulWidget {
  final List<String> item;
  final Function(String)? onChange;
  const AppSelectTime({super.key, required this.item, this.onChange});

  @override
  State<AppSelectTime> createState() => _AppSelectTimeState();
}

class _AppSelectTimeState extends State<AppSelectTime> {
  String activeIds = '';

  void toggleItemById(String id) {
    setState(() {
      activeIds = id;

      if (widget.onChange != null) {
        widget.onChange!(activeIds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.item.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.item[index];
          final isActive = activeIds == (item); // Status aktif

          // Pisahkan jam dan menit
          List<String> parts = item.split('.');
          int hour = int.parse(parts[0]);
          String minute = parts[1];

          // Tentukan AM atau PM
          String period = hour >= 12 ? "PM" : "AM";

          // Konversi jam ke format 12 jam
          hour = hour % 12 == 0 ? 12 : hour % 12;

          // Format waktu ke 12 jam
          String time12 = "$hour.$minute $period";

          EdgeInsets margin = EdgeInsets.only(
            left: index == 0 ? 14 : 0,
            right: index == widget.item.length - 1 ? 14 : 0,
          );

          return GestureDetector(
            onTap: () => toggleItemById(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: margin,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: isActive
                        ? const Color(0xFF4E4E4E)
                        : const Color(0xFFE8EAE9).withOpacity(0.08)),
                child: Text(
                  time12,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : const Color(0xFF8F8F8F)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
