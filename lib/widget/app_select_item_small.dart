import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/widget/app_skeleton.dart';

class AppSelectItemSmall extends StatefulWidget {
  final List<Map<String, dynamic>> item;
  final Function(int)? onChange;
  final int activeId;
  const AppSelectItemSmall(
      {super.key, required this.item, this.onChange, this.activeId = 0});

  @override
  State<AppSelectItemSmall> createState() => _AppSelectItemSmallState();

  static Widget loading() {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Jumlah skeleton placeholder
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AppSkeleton(
              borderRadius: BorderRadius.circular(23),
              width: 120,
            ),
          );
        },
      ),
    );
  }
}

class _AppSelectItemSmallState extends State<AppSelectItemSmall> {
  // final List<Map<String, dynamic>> category = [
  //   {'id': 1, 'name': 'Soccer'},
  //   {'id': 2, 'name': 'Basketball', 'icon': 'image 4.png'},
  //   {'id': 3, 'name': 'Football', 'icon': 'image 2.png'},
  //   {'id': 4, 'name': 'Baseball', 'icon': 'baseball_26be 1.png'},
  //   {'id': 5, 'name': 'Tennis', 'icon': 'image 7.png'},
  //   {'id': 6, 'name': 'Volleyball', 'icon': 'image 1.png'},
  // ];

  int activeIds = 0;
  @override
  void initState() {
    super.initState();
    activeIds = widget.activeId;
  }

  void toggleItemById(int id) {
    setState(() {
      if (widget.onChange != null && activeIds != id) {
        widget.onChange!(id);
      }
      activeIds = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.item.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.item[index];
          final isActive = activeIds == (item['id']); // Status aktif

          EdgeInsets margin = EdgeInsets.only(
            left: index == 0 ? 14 : 0,
            right: index == widget.item.length - 1 ? 14 : 0,
          );

          return GestureDetector(
            onTap: () => toggleItemById(item['id']),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: margin,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: isActive
                            ? const Color(0xFF4E4E4E)
                            : const Color(0xFFE8EAE9).withOpacity(0.08)),
                    child: Row(
                      children: [
                        if (item['icon'] != null) ...[
                          Image.asset(
                            'assets/${item['icon']}',
                            width: 20,
                            height: 20,
                            fit: BoxFit
                                .cover, // Menyesuaikan gambar dengan area yang tersedia
                          ),
                        ],
                        if (item['icon'] != null && isActive) ...[
                          const SizedBox(width: 8),
                        ],
                        if (isActive || item['icon'] == null) ...[
                          Text(
                            item['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: isActive
                                    ? Colors.white
                                    : const Color(0xFF8F8F8F)),
                          )
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
